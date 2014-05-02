# Script to configure a cron job to check MAUI is running properly and restart it
# if necessary.

unique template features/maui/server/maui-monitoring;

# File for caching information about reservations if enabled.
variable GIP_CE_CACHE_FILE ?= if ( GIP_CE_USE_CACHE ) {
                                error("GIP_CE_CACHE_FILE is required to use MAUI-based GIP plugin cache mode (normally defined by GIP configuration).");
                              } else {
                                undef;
                              };

# Command to use to run the GIP plugin
variable GIP_CE_PLUGIN_COMMAND ?= if ( GIP_CE_USE_CACHE ) {
                                    error("GIP_CE_PLUGIN_COMMAND is required to use MAUI-based GIP plugin cache mode (normally defined by GIP configuration).");
                                  } else {
                                    undef;
                                  };

# Name of wrapper to use to run the GIP plugin when cache mode is enabled.
# There must be one entry per supported plugin (see gip/ce.tpl for the list): keys must match those
# present in GIP_CE_PLUGIN_COMMAND.
variable MAUI_MONITORING_GIP_PLUGIN_WRAPPER ?= nlist(
  'ce',         MAUI_CONFIG_DIR + '/gip-info-dynamic-ce-plugin.sh',
  'scheduler',  MAUI_CONFIG_DIR + '/gip-info-dynamic-scheduler-plugin.sh',
);

# Frequency of MAUI monitoring cron
# Can be changed in case of MAUI instability...
# When using maui-monitoring to produce a reservation information cache,
# run more frequently.
variable MAUI_MONITORING_FREQ_MINUTES ?= if ( GIP_CE_USE_CACHE ) {
                                           5;
                                         } else {
                                           15;
                                         };
variable MAUI_MONITORING_FREQUENCY ?= "*/"+to_string(MAUI_MONITORING_FREQ_MINUTES)+" * * * *";

# File used to store output of mdiag command executed by maui-monitoring for later processing
# by lcg-info-dynamic-maui.
variable MAUI_MONITORING_DIAG_OUTPUT ?= '/tmp/maui-reservations.list';

# Options to pass to maui-monitoring.
# When using maui-monitoring to execute the MAUI-based GIP plugins, define the GIP plugin wrapper to use
# and set the maximum life time of the cache file to 4 x plugin frequency with a max value of 30 mn.
# This must be done for all defined GIP plugin entries.
# If cache mode is not used, return an empty string.
variable MAUI_MONITORING_OPTIONS ?= {
  if ( GIP_CE_USE_CACHE ) {
    cache_lifetime = 4 * MAUI_MONITORING_FREQ_MINUTES;
    if ( cache_lifetime > 30 ) {
      cache_lifetime = 30;
    };
    if ( cache_lifetime < 2*MAUI_MONITORING_FREQ_MINUTES ) {
      error('GIP plugin frequency too high. Must be <= 15mn to use cache mode.');
    };
    gip_wrappers = '';
    foreach (plugin;command;GIP_CE_PLUGIN_COMMAND) {
      if ( !is_defined(MAUI_MONITORING_GIP_PLUGIN_WRAPPER[plugin]) ) {
        error("No entry found for plugin '"+plugin+"' in MAUI_MONITORING_GIP_PLUGIN_WRAPPER (internal error)");
      } else if ( !is_defined(GIP_CE_CACHE_FILE[plugin]) ) {
        error("No entry found for plugin '"+plugin+"' in GIP_CE_CACHE_FILE (internal error)");
      } else {
        gip_wrappers = gip_wrappers + ' -gipwrapper '+MAUI_MONITORING_GIP_PLUGIN_WRAPPER[plugin]+':'+GIP_CE_CACHE_FILE[plugin];
      };
    };
    gip_wrappers +' -cacheage '+to_string(cache_lifetime)+' -diagOutput '+MAUI_MONITORING_DIAG_OUTPUT;
  } else {
    '';
  };
};


# Create maui-monitoring script.

include { 'components/filecopy/config' };
include { 'components/cron/config' };
include { 'components/altlogrotate/config' };

variable MAUI_MONITORING_SCRIPT ?= "/var/spool/maui/maui-monitoring";
variable MAUI_MONITORING_SCRIPT_CONTENTS ?= <<EOF;
#!/bin/sh

export PATH=/sbin:/usr/sbin:/bin:/usr/bin

mauibin=/usr/sbin/maui
mauisrv=maui
torquesrv=pbs_server

force_restart=0
run_gip_wrappers=0
reservation_file_tmp_def=/dev/null
mdiag_option=-S
plugin_index=0

# Maximum time cache of reservation list is considered valid in minutes
collect_cache_max_age=30

usage () {
  echo "Usage:    $(basename $0) [-force] [-diagOutput file] [-gipwrapper wrapper:ldif_file [--gipwrapper...]] [-cacheage minutes]"
  echo ""
  echo "    -cacheage minutes: maximum age of GIP plugin output file before it is considered obsolete and deleted. (D: ${collect_cache_max_age})."
  echo "    -diagOutput file: file to store result of mdiag command used to test MAUI for later processing by GIP plugins."
  echo "    -force: restart MAUI if it is alive but unresponsive to commands."
  echo "    -gipwrapper: command/script to launch the MAUI-based GIP plugin and the associated output LDIF file (separated by :)."
  echo "                 Multiple -gipwrapper are allowed."
  echo ""
}


while [ -n "$(echo $1 | grep '^-')" ]
do
  case $1 in
    # -cacheage: maximum age of the GIP plugin output before it is considered
    # obsolete and deleted. This allows to expire an output cache in case of
    # multiple failures to refresh information.
    -cacheage)
        shift
        collect_cache_max_age=$1
        if [ -z "${collect_cache_max_age}" ]
        then
          echo "-cacheage requires a number of minutes to be specified"
          exit 1
        fi
        ;;

    # -diagOutput: name of file where to store ouput of mdiag command used to 
    # test MAUI for later processing by GIP plugins.
    -diagOutput)
        shift
        if [ -n "$1" ]
        then
          reservation_file_tmp=$1
        else
          echo "-diagOutput requires a file name"
          exit 1
        fi
        ;;
        
    # -force: restart MAUI if it is alive but not responding to user commands.
    # Not that this is a normal situation when MAUI is overloaded that normally
    # does not require a restart.
    -force)
        force_restart=1
        ;;

    # -gipwrapper allows to run a GIP plugin as part of this script. Plugin output
    # will be written in the output file specified with the script name (separated
    # by a ':'). There is no default for the LDIF file name.
    # When -gipwrapper is used, the script is used as an alternative to running 'diagnose'
    # command to test MAUI. This avoids running multiple diagnose commands that may take
    # a lot of time on a loaded Torque/MAUI server.
    # The resulting LDIF file can be used by the GIP plugin (doing a cat command).
    # This is particularly useful when running multiple CEs in front of the
    # same Torque/MAUI cluster as most CEs cannot access the MAUI information.
    # Several --gipwrapper options can be specified.
    -gipwrapper)
        run_gip_wrappers=1
        mdiag_option=-r
        shift
        gip_plugin_wrapper[$plugin_index]=$(echo $1 | awk -F: '{print $1}')
        gip_plugin_ldif[$plugin_index]=$(echo $1 | awk -F: '{print $2}')
        if [ -z "${gip_plugin_wrapper[$plugin_index]}" ]
        then
          echo "-gipwrapper requires path of GIP plugin wrapper to be specified"
          exit 1
        fi
        if [ -z "${gip_plugin_ldif[$plugin_index]}" ]
        then
          echo "-gipwrapper requires path of the output LDIF file to be specified"
          exit 1
        fi
        if [ -z "${reservation_file_tmp}" ]
        then
          reservation_file_tmp=/tmp/maui-reservation-list.tmp
        fi
        let plugin_index=$((plugin_index + 1))
        ;;

    *)
      echo "Invalid option ($1)"
      usage
      exit 1
      ;;
      
  esac
  shift
done

if [ -z "${reservation_file_tmp}" ]
then
  reservation_file_tmp=${reservation_file_tmp_def}
fi

service $mauisrv status > /dev/null 2>&1
status=$?
if [ ${status} -ne 0 ]
then
  if [ ${status} -eq 3 -a ${force_restart} -eq 0 ]
  then
    echo "`date` - MAUI has been properly stopped. Not restarting it (use -force to restart it)..."
  else
    echo "`date` - MAUI not running. Restarting..."
    service $mauisrv start
  fi
else
  restart_maui=0
  # Check maui is responding
  # If not, check again if maui is there as mdiag command sometimes crashes maui ...
  mdiag ${mdiag_option} > ${reservation_file_tmp} 2>&1
  if [ $? -ne 0 ]
  then
    mauipid=`ps -e -opid="",cmd="" | awk "{if (\\$2==\"${mauibin}\") print \\$1}"`
    if [ -z "$mauipid" ]
    then
      echo "`date` - MAUI service looked ok but MAUI not running. Restarting..."
      restart_maui=1
    else
      if [ ${force_restart} -eq 0 ]
      then 
         echo "`date` - MAUI running (pid=$mauipid) but not responding (use -force to restart it)."
      else
         echo "`date` - MAUI running (pid=$mauipid) but not responding. Killing and restarting..."
         kill -KILL $mauipid
         restart_maui=1
      fi
    fi
    echo `date` - System load statictics :
    uptime
    vmstat
    if [ $restart_maui -eq 1 ]
    then
      service $mauisrv start
    fi

  # If mdiag succeeded and and maui-monitoring is used to run GIP plugins in cache mode:
  # execute them (lcg-info-dynamic-maui will use mdiag output as input).
  elif [ ${run_gip_wrappers} -eq 1 ]
  then
    i=0
    for wrapper in ${gip_plugin_wrapper[@]}
    do
      ldif_file=${gip_plugin_ldif[$i]}
      gip_plugin_out_tmp=/tmp/$(basename ${wrapper}).out
      gip_plugin_err_file=/tmp/$(basename ${wrapper}).err
      ${wrapper} > ${gip_plugin_out_tmp} 2> ${gip_plugin_err_file}
      # Avoid overwritting an existing LDIF file with an empty one
      if [ $? -eq 0 -a -s ${gip_plugin_out_tmp} ]
      then
        cp ${gip_plugin_out_tmp} ${ldif_file}
      else
        echo "Plugin wrapper ${wrapper} error or empty output. Ignoring."
      fi
      if [ -e ${gip_plugin_err_file} -a ! -s ${gip_plugin_err_file} ]
      then
        rm ${gip_plugin_err_file}
      fi
      let i=$((i + 1))
    done
  fi
fi

# If running GIP plugins in cache mode, checked the existing GIP plugin 
# outputs are not obsolete. Else delete them. Iterate over all plugins.
# This check must be done whether MAUI is running properly or not.
if [ ${run_gip_wrappers} -eq 1 ]
then
  for ldif_file in ${gip_plugin_ldif[@]}
  do
    if [ -e ${ldif_file} ]
    then
      if [ -n "$(find ${ldif_file} -cmin +${collect_cache_max_age})" ]
      then
        echo "Existing GIP plugin output cache (${ldif_file}) is obsolete (older than ${collect_cache_max_age} minutes). Deleting it..."
        rm ${ldif_file}
      fi
    fi
    let i=$((i + 1))
  done
fi


EOF

# Now actually add the script to the configuration and configure it as a cron job.
'/software/components/filecopy/services' =
  npush(escape(MAUI_MONITORING_SCRIPT),
        nlist('config',MAUI_MONITORING_SCRIPT_CONTENTS,
              'owner','root:root',
              'perms', '0755'));

"/software/components/cron/entries" =
  push(nlist(
    "name","maui-monitoring",
    "user","root",
    "frequency", MAUI_MONITORING_FREQUENCY,
    "command", MAUI_MONITORING_SCRIPT+' '+MAUI_MONITORING_OPTIONS));

"/software/components/altlogrotate/entries/maui-monitoring" =
  nlist("pattern", "/var/log/maui-monitoring.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 6);


#TO_BE_FIXED: Just not working
# Create wrapper used by maui-monitoring to execute the GIP plugin if cache mode is enabled.
# Iterate over all commands defined in GIP_CE_PLUGIN_COMMAND.
'/software/components/filecopy/services' = {
  if ( GIP_CE_USE_CACHE ) {
    foreach (plugin;command;GIP_CE_PLUGIN_COMMAND) {
      if ( is_defined(MAUI_MONITORING_GIP_PLUGIN_WRAPPER[plugin]) ) {
        # Use already producted 'mdiag -R' output rather than reexecuting.
        if ( plugin == 'ce' ) {
          command = command + ' --diagnose-output ' + MAUI_MONITORING_DIAG_OUTPUT;
        };
        contents = "#!/bin/sh\n" + 
               "export PYTHONPATH=/usr/lib/python:${PYTHONPATH}\n" + command + "\n";
        SELF[escape(MAUI_MONITORING_GIP_PLUGIN_WRAPPER[plugin])] = nlist('config', contents,
                                                                         'owner', 'root:root',
                                                                         'perms', '0755',
                                                                        );
      } else {
        error("No entry found for plugin '"+plugin+"' in MAUI_MONITORING_GIP_PLUGIN_WRAPPER (internal error)");
      };
    };
  };
  SELF;
};
