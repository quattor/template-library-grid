# This template does the Xrootd monitoring configuration for the disk servers
# and the local redirector.
# It must be executed after the Xrootd federation configuration that does the monitoring
# configuration for the federation redirectors.

unique template personality/xrootd/monitoring;

# Include federation parameters, in case this node is a federation member
include { 'personality/xrootd/env_federation' };


# Configure Xrootd monitoring on disk servers and local redirector if enabled for one federation

variable XROOTD_REPORTING_DESTINATIONS = {
  foreach (i;federation;XROOTD_FEDERATION_LIST) {
    params = XROOTD_FEDERATION_PARAMS[federation];
    if ( is_defined(params['reporting_host']) ) {
      SELF[length(SELF)] = params['reporting_host'];
    };
  };
  # No more than 2 hosts can be specified for the reporting directive
  # in xrootd v3.
  max_reporting_host = 2;
  if ( length(SELF) > max_reporting_host ) {
    error(format('Too many reporting hosts configured (maximum=%d)',max_reporting_host));
  };
  SELF;
};

'/software/components/xrootd/options' = {
  monitoring_dest = '';
  max_monitoring_hosts = 2;
  monitoring_host_num = 0;
  if ( is_defined(XROOTD_MONITORING_DESTINATIONS) ) {
    monitoring_host_num = length(XROOTD_MONITORING_DESTINATIONS);
    if ( monitoring_host_num > max_monitoring_hosts ) {
      error(format('Too many monitoring hosts configured (maximum=%d)',max_monitoring_host));
    };
    event_list = '';
    foreach (i;event;XROOTD_MONITORING_EVENTS) {
      event_list = event_list + ' ' + event;
    };
    foreach (i;host;XROOTD_MONITORING_DESTINATIONS) {
      monitoring_dest = monitoring_dest + ' ' + format('dest %s %s', event_list, host);
    };
    monitoring_options = XROOTD_MONITORING_OPTIONS;
  } else if ( length(XROOTD_FEDERATION_LIST) > 0 ) {
    debug(format('%s: one or several federations configured',OBJECT));
    foreach (i;federation;XROOTD_FEDERATION_LIST) {
      params = XROOTD_FEDERATION_PARAMS[federation];
      if ( is_defined(params['monitoring_host']) ) monitoring_host_num = monitoring_host_num + 1;
    };
    if ( monitoring_host_num > max_monitoring_hosts ) {
      error(format('Too many monitoring hosts configured (maximum=%d)',max_monitoring_host));
    };
    foreach (i;federation;XROOTD_FEDERATION_LIST) {
      debug(format('%s: configuring monitoring for federation %s',OBJECT,federation));
      params = XROOTD_FEDERATION_PARAMS[federation];
      if ( is_defined(params['monitoring_host']) ) {
        if ( !is_defined(params['monitoring_events']) ) {
          params['monitoring_events'] = XROOTD_MONITORING_EVENTS;
        };
        if ( is_defined(params['monitoring_options']) ) {
          monitoring_options = params['monitoring_options'];
        } else {
          monitoring_options = XROOTD_MONITORING_OPTIONS;
        };
        event_list = '';
        foreach (k;event;params['monitoring_events']) {
          event_list = event_list + ' ' + event;
        };
        monitoring_dest = monitoring_dest + ' ' + format('dest %s %s', event_list, params['monitoring_host']);
      };
    };
    # Use federation monitoring options if there is only one configured, else the global variable
    if ( monitoring_host_num > 1 ) {
      debug(format('%s: more than one federation with monitoring enabled, using global monitoring options',OBJECT));
      monitoring_options = XROOTD_MONITORING_OPTIONS;
    };
  };
  if ( monitoring_host_num > 0 ) {
    SELF['monitoringOptions'] = monitoring_options + ' ' + monitoring_dest;
  };
  if ( length(XROOTD_REPORTING_DESTINATIONS) > 0 ) {
    host_list = '';
    foreach (i;host;XROOTD_REPORTING_DESTINATIONS) {
      if ( length(host_list) > 0 ) host_list = host_list + ',';
      host_list = host_list + host;
    };
    # FIXME: use federation reporting options if there is only one configured, else the global variable
    reporting_options = XROOTD_REPORTING_OPTIONS;
    SELF['reportingOptions'] =  host_list + ' ' + reporting_options;
  };
  SELF; 
};


