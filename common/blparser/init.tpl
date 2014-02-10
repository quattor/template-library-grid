# This template defines configuration parameters for the different batch
# systems that can be used with BLParser.
# It can be included by other services which may need to access this information (like CREAM CE).

unique template common/blparser/init;

# Define default log level (normal=1,debug=2).
# It is possible to define one specific level per parser and a default
# level. If a default level is not yet defined, the minimum level will
# be used as default.
variable BLPARSER_LOG_LEVEL = {
  SELF['DEFAULT'] = 1;
  SELF;
};

# BLAHPD_LOCATION is required by /etc/init.d/glite-ce-check-blparser
variable BLAHPD_LOCATION ?= '/usr';

# blparser log directory
variable BLPARSER_LOG_DIR ?= GLITE_LOCATION_LOG;

# BLAH timeout
variable BLAH_CHILD_POLL_TIMEOUT ?= 200;

# BLAH jobId prefix. It MUST be a 6 chars long, begin with 'cr' and terminate
# with '_'. It is important in case there's more than one CE connecting to the
# same BLAH blparser. In this case, it is suggested that each CREAM_CE has it
# own prefix.
variable BLAH_JOBID_PREFIX ?= 'cream_';

# BLAH new parser (BLParser-less) configuration
variable BLAH_PURGE_INTERVAL ?= 5000000;   # About 2months
variable BLAH_UPDATER ?= nlist(
  'lsf', GLITE_LOCATION+'/bin/BUpdaterLSF',
  'pbs', GLITE_LOCATION+'/bin/BUpdaterPBS',
);
variable BLAH_NOTIFIER ?= nlist(
  'lsf', GLITE_LOCATION+'/bin/BNotifier',
  'pbs', GLITE_LOCATION+'/bin/BNotifier',
);
variable BLAH_UPDATER_DEBUG_LEVEL ?= 2;
variable BLAH_NOTIFIER_DEBUG_LEVEL ?= 2;
variable BLAH_UPDATER_DEBUG_FILE ?= 'glite-ce-bupdater.log';
variable BLAH_NOTIFIER_DEBUG_FILE ?= 'glite-ce-bnotifier.log';

# Specifies if the new blparser (set it to 'true') or the old one.
# Note that the new parser requires direct access to LRMS logs by the CE.
variable BLPARSER_WITH_UPDATER_NOTIFIER ?= false;

# blah configuration file
variable BLAH_CONFIG_FILE = GLITE_LOCATION + '/etc/blah.config';
variable BLAH_LOG_DIR = '/var/log/accounting';
variable BLAH_LOG_FILE = 'blahp.log';

# Which LRMS to enable in blparser
# BLPARSER_LRMS_PARMAS must contain one entry per supported LRMS.
# Support for a particular LRMS should be disabled by default.
variable BLPARSER_LRMS_PARAMS ?= {
  SELF['lsf'] = nlist('enabled', 'no',
                      'logFile', 'glite-blparser-lsf.log',
                      'port', 33333,
                      'creamPort', 56566,
                      'numOfDaemons', 1,
                     );
  SELF['pbs'] = nlist('enabled', 'no',
                      'logFile', 'glite-blparser-pbs.log',
                      'port', 33332,
                      'creamPort', 56565,
                      'numOfDaemons', 1,
                     );

  SELF;
};

# Define batch system name based on CREAM one if defined. Else handle
# special cases like 'lcgpbs'
variable BLPARSER_BATCH_SYS ?= if ( is_defined(CREAM_BATCH_SYS) ) {
                                 CREAM_BATCH_SYS;
                               } else if ( CE_BATCH_SYS == 'lcgpbs' ) {
                                 'pbs';
                               } else {
                                 CE_BATCH_SYS;
                               };
                               
variable BLPARSER_LRMS_PARAMS = {
  if ( is_defined(SELF[BLPARSER_BATCH_SYS]) ) {
    SELF[BLPARSER_BATCH_SYS]['enabled'] = 'yes';
  } else {
    error("LRMS '"+BLPARSER_BATCH_SYS+"' is not supported by BLParser");
  };

  # Define blparser log level
  foreach (lrms;params;SELF) {
    if ( is_defined(BLPARSER_LOG_LEVEL[BLPARSER_BATCH_SYS]) ) {
      params['logLevel'] = BLPARSER_LOG_LEVEL[BLPARSER_BATCH_SYS];
    } else {
      params['logLevel'] = BLPARSER_LOG_LEVEL['DEFAULT'];
    };
  };
  
  debug('BLPARSER_LRMS_PARAMS: '+to_string(SELF));

  SELF;
}; 


