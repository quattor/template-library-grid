# Template configuring Torque client.
# It should not be executed on Torque server

unique template feature/torque2/client/config;

# This variable is normally defined as part of VO configuration
variable CE_SHARED_HOMES ?= false;

# This variable defines directory for customization points (scripts) used by WMS
variable GLITE_WMS_LOCAL_CUSTOMIZATION_DIR ?= GLITE_LOCATION + '/etc/wms';

# Variable to force MOM startup even if the current node is node in
# worker node list.
variable TORQUE_FORCE_MOM_STARTUP ?= false;

# pbs-monitoring frequency.
# Must be specified as valid cron values
variable PBS_MONITORING_INTERVAL_MINUTE ?= "*/15";


# include configuration common to client and server
include { 'feature/torque2/config' };

# ----------------------------------------------------------------------------
# chkconfig
# ----------------------------------------------------------------------------
include { 'components/chkconfig/config' };

# Variable to define where is the working area for jobs on WN.
# Default value used if TORQUE_TMPDIR not previously defined.
# If TORQUE_TMPDIR is null, don't define Torque client tmpdir attribue.
variable TORQUE_TMPDIR = if ( exists(TORQUE_TMPDIR) &&
                              (is_defined(TORQUE_TMPDIR) || is_null(TORQUE_TMPDIR)) ) {
                           SELF;
                         } else {
                           TORQUE_CONFIG_DIR+"/tmpdir";
                         };


# Enable and start MOM service only if the node is listed as a worker
# node in site configuration, except if TORQUE_FORCE_MOM_STARTUP is true.
# This is done to avoid potential error messages on Torque master when
# client tries to contact server.
"/software/components/chkconfig/service/pbs_mom" = {
  wn_list = nlist();
  if ( exists(WORKER_NODES_NLIST[FULL_HOSTNAME]) || TORQUE_FORCE_MOM_STARTUP ) {
    SELF['on'] = '';
    SELF['off'] = null;
  } else {
    SELF['on'] = null;
    SELF['off'] = '';
  };
  SELF['startstop'] = true;
  SELF;
};


# ----------------------------------------------------------------------------
# Configuring munge
# ----------------------------------------------------------------------------

include { 'feature/torque2/munge/config' };

# ----------------------------------------------------------------------------
# Configure NFS mount points for CREAM CE sandbox directory if requested.
# NFS sharing of CREAM CE sandbox directory is enabled with variable
# CREAM_SANDBOX_MPOINTS which can contain one entry per CE host sharing its
# sandbox directory with WNs.
# Sharing is disabled if variable CREAM_SANDBOX_SHARED_FS is defined with a
# value different than 'nfs[34]'.
# ----------------------------------------------------------------------------
include { 'feature/nfs/cream-sandbox' };



# ----------------------------------------------------------------------------
# pbsclient
# ----------------------------------------------------------------------------
include { 'components/pbsclient/config' };
include { 'components/profile/config' };

"/software/components/pbsclient/configPath" = 'mom_priv/config';

"/software/components/pbsclient/behaviour" = "OpenPBS";

"/software/components/pbsclient/initScriptPath" = "/etc/init.d/pbs_mom";
"/software/components/pbsclient/restricted" = list(TORQUE_SERVER_HOST);

"/software/components/pbsclient/logEvent" = 255;

"/software/components/pbsclient/tmpdir" = TORQUE_TMPDIR;

# Report working area usage/size for easier monitoring
"/software/components/pbsclient/resources" = if ( !is_null(TORQUE_TMPDIR) ) {
                                                push('size[fs='+TORQUE_TMPDIR+']');
                                             } else {
                                               return(null);
                                             };

# If WN_SHARED_AREAS is defined, add all the filesystems defined
# to directpaths as home directories are not necessarily under /home.
# Entries not related to home directory are not really needed but there
# is no side effect to add them.
"/software/components/pbsclient/directPaths" = {
  if ( is_defined(WN_SHARED_AREAS) ) {
    if ( !is_nlist(WN_SHARED_AREAS) ) {
      error("WN_SHARED_AREAS must be a nlist");
    };
    foreach(e_mnt_point;mnt_path;WN_SHARED_AREAS) {
      mnt_point = unescape(e_mnt_point);
      SELF[length(SELF)] = nlist("locations",'*.'+DOMAIN+':'+mnt_point,
    	                           "path",mnt_point,
    		                        );
      # When TORQUE_SERVER_PRIV_HOST is defined,
      ## add an explicit entry to $usecp with TORQUE_SERVER_HOST
      if (exists(TORQUE_SERVER_PRIV_HOST) && is_defined(TORQUE_SERVER_PRIV_HOST)) {
	      SELF[length(SELF)] = nlist("locations",TORQUE_SERVER_HOST+':'+mnt_point,
    	                             "path",mnt_point,
    		                          );
      };
	  };
	};

  # If WN_SHARED_AREAS is not defined or is empty (but CE_SHARED_HOME is true),
  # add /home to SELF for backward compatibility
  if ( (length(SELF) == 0) && is_defined(CE_SHARED_HOME) && CE_SHARED_HOME ) {
    debug('WN_SHARED_AREAS undefined or empty but CE_SHARED_HOME true: add /home to Torque directPaths');
    SELF[length(SELF)] = nlist("locations",'*.'+DOMAIN+':/home',
                               "path","/home"
                              );
  };

  # If CREAM_SANDBOX_MPOINTS is defined, add an entry for each corresponding CE sandbox
  if ( is_defined(CREAM_SANDBOX_MPOINTS) ) {
    foreach (ce;mpoint;CREAM_SANDBOX_MPOINTS) {
      if ( is_defined(CREAM_SANDBOX_DIRS[ce]) ) {
        sandbox_path = CREAM_SANDBOX_DIRS[ce];
      } else if ( is_defined(CREAM_SANDBOX_DIRS['DEFAULT']) ) {
        sandbox_path = CREAM_SANDBOX_DIRS['DEFAULT'];
      };
      if ( exists(sandbox_path) ) {
        debug('Adding Torque directPaths entry for CE '+ce+' sandbox ('+sandbox_path+' mounted on '+mpoint+')');
        SELF[length(SELF)] = nlist("locations",ce+':'+sandbox_path,
                                   "path",mpoint,
                                  );
      } else {
        error('CREAM CE '+ce+' sandbox directory undefined (check variable CREAM_SANDBOX_MPOINTS)');
      };
    };
  };

  if ( length(SELF) == 0 ) {
    null;
  } else {
    SELF;
  };
};


# ----------------------------------------------------------------------------
# Configuration of EDG_WL_SCRATCH
#
# EDG_WL_SCRATCH will be set to the PBS tmpdir if $TMPDIR is defined
# and the PBS_NODEFILE is not defined.  That is, it will be defined
# for non-MPI jobs.  This is done in the profile.d scripts below.
#
# In addition, current directory is defined to $TMPDIR for non-MPI jobs
# in gLite WMS custmization point 1 (cp_1.sh) as gWMS job wrapper no longer
# does it.
# ----------------------------------------------------------------------------
include { 'components/filecopy/config' };
include { 'components/profile/config' };

variable CONTENTS = <<EOF;
# If $TMPDIR is defined and $PBS_NODEFILE is not (non-MPI job), then
# set the EDG_WL_SCRATCH variable to put sandboxes into the $TMPDIR area.
if [ "x$TMPDIR" != "x" ]; then
  if [ "x$PBS_NODEFILE" = "x" ]; then
    export EDG_WL_SCRATCH=$TMPDIR
  else
    if [ `wc -l $PBS_NODEFILE|awk '{print $1}'` = "1" ]; then
      export EDG_WL_SCRATCH=$TMPDIR
    fi
  fi
fi

EOF

# Now actually add the file to the configuration.
"/software/components/filecopy/services" =
  npush(escape("/etc/profile.d/edg-wl-scratch.sh"),
        nlist("config",CONTENTS,
              "perms", "0755")
       );


variable CONTENTS = <<EOF;
# If $TMPDIR is defined and $PBS_NODEFILE is not (non-MPI job), then
# set the EDG_WL_SCRATCH variable to put sandboxes into the $TMPDIR area.
if ( $?TMPDIR ) then
  if ( (! $?PBS_NODEFILE) || (`wc -l $PBS_NODEFILE|awk '{print $1}'` == "1") ) then
    setenv EDG_WL_SCRATCH $TMPDIR
  endif
endif
EOF

# Now actually add the file to the configuration.
"/software/components/filecopy/services" =
  npush(escape("/etc/profile.d/edg-wl-scratch.csh"),
        nlist("config",CONTENTS,
              "perms", "0755")
       );


variable CONTENTS = <<EOF;
# If $TMPDIR is defined and $PBS_NODEFILE is not (non-MPI job), then change
# directory to $TMPDIR area.
#!/bin/sh
if [ "x$TMPDIR" != "x" ]; then
  if [ "x$PBS_NODEFILE" = "x" ]; then
    cd $TMPDIR
  else
    if [ `wc -l $PBS_NODEFILE|awk '{print $1}'` = "1" ]; then
      cd $TMPDIR
	  fi
  fi
fi
EOF

# Now actually add the file to the configuration.
"/software/components/filecopy/services" =
  npush(escape(GLITE_WMS_LOCAL_CUSTOMIZATION_DIR+'/cp_1.sh'),
        nlist("config",CONTENTS,
              "perms", "0755")
       );

'/software/components/profile/env/GLITE_LOCAL_CUSTOMIZATION_DIR' = GLITE_WMS_LOCAL_CUSTOMIZATION_DIR;


# ----------------------------------------------------------------------------
# Define a cron job to ensure that PBS server is running properly.
# Script created as part of server/client common config : PBS_MONITORING_SCRIPT
# defined to the name of the created script.
# ----------------------------------------------------------------------------
include { 'components/cron/config' };
include { 'components/altlogrotate/config' };

variable PBS_MONITORING_SCRIPT ?= undef;

"/software/components/cron/entries" = if ( is_defined(PBS_MONITORING_SCRIPT) ) {
                                        push(nlist("name","pbs-monitoring",
                                                   "user","root",
                                                   "timing", nlist("minute", PBS_MONITORING_INTERVAL_MINUTE),
                                                   "command", PBS_MONITORING_SCRIPT+' -mom'));
                                      } else {
                                        SELF;
                                      };

"/software/components/altlogrotate/entries" = {
  if ( is_defined(PBS_MONITORING_SCRIPT) ) {
    SELF['pbs-monitoring'] = nlist("pattern", "/var/log/pbs-monitoring.ncm-cron.log",
                                   "compress", true,
                                   "missingok", true,
                                   "frequency", "monthly",
                                   "create", true,
                                   "ifempty", true,
                                   "rotate", 1);
  };
  SELF;
};


# ----------------------------------------------------------------------------
# cron
# ----------------------------------------------------------------------------
include { 'components/cron/config' };

"/software/components/cron/entries" =
  push(nlist(
    "name","mom-logs",
    "user","root",
    "frequency", "33 3 * * *",
    "command", "find "+TORQUE_CONFIG_DIR+"/mom_logs -mtime +7 -exec gzip -9 {} \\;"));


# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------
include { 'components/altlogrotate/config' };

"/software/components/altlogrotate/entries/mom-logs" =
  nlist("pattern", "/var/log/mom-logs.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

variable TORQUE_COMMAND_LINKS ?= false;
include { 'components/symlink/config' };
"/software/components/symlink/links" = {
  if (TORQUE_COMMAND_LINKS) {
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qstat",
        "target", "/usr/bin/qstat-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qsub",
        "target", "/usr/bin/qsub-torque",
        "replace", nlist("link","yes"),
        "exists", true,                       
    );  
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qhold",
        "target", "/usr/bin/qhold-torque",
        "replace", nlist("link","yes"),
        "exists", true,         
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qrls",
        "target", "/usr/bin/qrls-torque",
        "replace", nlist("link","yes"),
        "exists", true,                       
    );  
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qalter",
        "target", "/usr/bin/qalter-torque",
        "replace", nlist("link","yes"),
        "exists", true,                       
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qselect",
        "target", "/usr/bin/qselect-torque",
        "replace", nlist("link","yes"),
        "exists", true,                       
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qdel",
        "target", "/usr/bin/qdel-torque",
        "replace", nlist("link","yes"),
        "exists", true,                       
    );
  };  
  if ( is_defined(SELF) ) {
    SELF;
  } else {
    null;
  };
};
