
unique template glite/se_dpm/check-dpm-daemons;

include { 'components/filecopy/config' };

variable DPM_CHECKDAEMONS_SCRIPT = 'check-dpm-daemons';
variable DPM_CHECKDAEMONS_FILE = '/usr/bin/'+DPM_CHECKDAEMONS_SCRIPT;


variable DPM_CHECKDAEMONS_TEMPLATE = <<EOF;
#!/bin/bash

service=/sbin/service

for daemon in DPM_DAEMONS
do
  #echo Checking $daemon status...
  ${service} $daemon status > /dev/null
  status=$?
  if [ $status -eq 2 -o $status -eq 1 ]         # Daemon is dead
  then
    echo "Restarting $daemon..."
    ${service} $daemon start
  elif [ $status -eq 3 ]
  then
    echo "Daemon $daemon has been intentionally stopped. Not restarted."
  elif [ $status -ne 0 ]
  then
    echo "$0: internal error during daemon $daemon check ($service returned unhandled status $status)"
  fi
done

EOF

# /software/components/dpmlfc has a very complicated schema...
variable DPM_ENABLED_SERVICES = {
  contents = '';
  foreach (service;entries;value('/software/components/dpmlfc')) {
    if ( is_nlist(entries) ) {
      foreach (host;host_params;entries) {
        if ( host == FULL_HOSTNAME ) {
          if ( service == 'copyd' ) {
            contents = contents + ' dpmcopyd';
          } else if ( service == 'dpm' ) {
            contents = contents + ' dpm';
          } else if ( service == 'dpns' ) {
            contents = contents + ' dpnsdaemon';
          } else if ( service == 'gsiftp' ) {
            contents = contents + ' dpm-gsiftp';
          } else if ( service == 'rfio' ) {
            contents = contents + ' rfiod';
          } else if ( service == 'srmv1' ) {
            contents = contents + ' srmv1';
          } else if ( service == 'srmv2' ) {
            contents = contents + ' srmv2';
          } else if ( service == 'srmv22' ) {
            contents = contents + ' srmv2.2';
          } else if ( service == 'xroot' ) {
            contents = contents + ' xrootd ';
          };
        };
      };
    } else {
      if ( is_defined(entries) ) {
        debug ('Host list for service '+service+' has an unexpected format (should be a nlist)');
      };
    };
  };
  contents;
};


# Create script with appropriate daemon list to check

'/software/components/filecopy/services' = {
  if ( length(DPM_ENABLED_SERVICES) > 0 ) {
    contents = replace('DPM_DAEMONS',DPM_ENABLED_SERVICES,DPM_CHECKDAEMONS_TEMPLATE);
    SELF[escape(DPM_CHECKDAEMONS_FILE)] =  nlist('config', contents,
                                                 'owner', 'root:root',
                                                 'perms', '0755'
                                                );
  };
  SELF;
};


# Add the script as a cron job if interval is greater than 0

"/software/components/cron/entries" = {
  if ( is_defined(DPM_CHECKDAEMONS_INTERVAL) && (DPM_CHECKDAEMONS_INTERVAL > 0) ) {
    SELF[length(SELF)] = nlist("name",DPM_CHECKDAEMONS_SCRIPT,
                               "user","root",
                               "frequency", '*/'+to_string(DPM_CHECKDAEMONS_INTERVAL)+" * * * *",
                               "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; " + DPM_CHECKDAEMONS_FILE,
                              );
  };
  SELF;
};

"/software/components/altlogrotate/entries" = {
  if ( is_defined(DPM_CHECKDAEMONS_INTERVAL) && (DPM_CHECKDAEMONS_INTERVAL > 0) ) {
    SELF[DPM_CHECKDAEMONS_SCRIPT] = nlist("pattern", "/var/log/"+DPM_CHECKDAEMONS_SCRIPT+".ncm-cron.log",
                                          "compress", true,
                                          "missingok", true,
                                          "frequency", "weekly",
                                          "create", true,
                                          "ifempty", true,
                                         );
  };
  SELF;
};

