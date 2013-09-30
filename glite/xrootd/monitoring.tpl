# This template does the Xrootd monitoring configuration for the disk servers
# and the local redirector.
# It must be executed after the Xrootd federation configuration that does the monitoring
# configuration for the federation redirectors.

unique template glite/xrootd/monitoring;

# Include federation parameters, in case this node is a federation member
include { 'glite/xrootd/env_federation' };


# Configure Xrootd monitoring on disk servers and local redirector if enabled for one federation

# Configure Xrootd monitoring on disk servers and local redirector if enabled for one federation
variable XROOTD_MONITORING_DESTINATIONS = {
  foreach (i;federation;XROOTD_FEDERATION_LIST) {
    params = XROOTD_FEDERATION_PARAMS[federation];
    if ( is_defined(params['monitoring_host']) ) {
      SELF[length(SELF)] = params['monitoring_host'];
    };
  };
  SELF;
};

variable XROOTD_REPORTING_DESTINATIONS = {
  foreach (i;federation;XROOTD_FEDERATION_LIST) {
    params = XROOTD_FEDERATION_PARAMS[federation];
    if ( is_defined(params['reporting_host']) ) {
      SELF[length(SELF)] = params['reporting_host'];
    };
  };
  SELF;
};

'/software/components/xrootd/options' = {
  if ( length(XROOTD_MONITORING_DESTINATIONS) > 0 ) {
    host_list = '';
    foreach (i;host;XROOTD_MONITORING_DESTINATIONS) {
      host_list = host_list + ' ' + host;
    };
    SELF['monitoringOptions'] =  XROOTD_MONITORING_OPTIONS + ' ' + host_list;
  };
  if ( length(XROOTD_REPORTING_DESTINATIONS) > 0 ) {
    host_list = '';
    foreach (i;host;XROOTD_REPORTING_DESTINATIONS) {
      host_list = host_list + ' ' + host;
    };
    SELF['reportingOptions'] =  host_list + ' ' + XROOTD_REPORTING_OPTIONS;
  };
  SELF; 
};


