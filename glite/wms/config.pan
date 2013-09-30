unique template glite/wms/config;

## Define default value for various variables
variable WMS_LCMAPS_DB_FILE ?= if ( exists(LCMAPS_WMS_DB_FILE) && is_defined(LCMAPS_WMS_DB_FILE) ) {
                                 LCMAPS_WMS_DB_FILE;
                               } else {
                                 LCMAPS_DB_FILE;
                               };
variable WMS_LOCATION_VAR ?= EMI_LOCATION_VAR;
variable WMS_LOCATION_ETC ?= EMI_LOCATION_ETC;
variable WMS_LOCATION ?= EMI_LOCATION;
variable WMS_LOCATION_LOG ?= '/var/log/wms';
variable WMS_LOCATION_TMP ?= EMI_LOCATION_TMP;
variable WMS_LOCATION_SBIN ?= '/usr/sbin';
variable WMS_CONFIG_DIR ?= WMS_LOCATION_ETC + '/glite-wms'; 


## Use LB_MYSQL_ADMINUSER/PWD both on WMS and LB to ensure consistency if they are on the same node
variable LB_MYSQL_ADMINUSER ?= 'root';
variable LB_MYSQL_ADMINPWD ?= 'myclearpass';
variable WMS_MYSQL_SERVER ?= FULL_HOSTNAME;

## Default is not to use a password as WMS doesn't allow to specify it in its configuration
variable WMS_LBPROXY_DB_NAME ?= 'lbserver20';
variable WMS_DB_PWD ?= '';
variable WMS_DB_USER ?= 'lbserver';
variable WMS_LBPROXY_DB_INIT_SCRIPT ?= '/etc/glite-lb/glite-lb-dbsetup.sql';
variable WMS_SERVICES = list('wmproxy','wm','lm','jc','ice');
variable WMS_AUX_SERVICES = list('proxy-renewald','lb-bkserverd');
variable GLITE_LB_TYPE ?= 'proxy';

# WMProxy GACL File
variable WMS_GACL_FILE ?= WMS_CONFIG_DIR + '/glite_wms_wmproxy.gacl';

#-----------------------------------------------------------------------------
# LB Server Configuration
#-----------------------------------------------------------------------------

variable WMS_LB_SERVER_PORT ?= 9000;
variable WMS_LB_SERVER_HOST ?= FULL_HOSTNAME;
variable WMS_LB_SERVER ?= {
  lb_server="";
  if(is_string(WMS_LB_SERVER_HOST)) {
    # specify the double quotes, so that we can use lists of LB Servers
    lb_server='"' + WMS_LB_SERVER_HOST + ':' + to_string(WMS_LB_SERVER_PORT) + '"';
  } else {		
    if(is_list(WMS_LB_SERVER_HOST) ) {
      foreach(k;host;WMS_LB_SERVER_HOST) {
        if(! is_string(host) ) {
          error('one of the WMS_LB_SERVER_HOST list is not a string : ' + to_string(host));
        };
        if(lb_server != "") {
          lb_server = lb_server + ",";
        };
        # specify the double quotes, so that we can use lists of LB Servers
        lb_server = lb_server + '"' + host + ':' + to_string(WMS_LB_SERVER_PORT) + '"' ;
      };
    } else {
      error("variable WMS_LB_SERVER_HOST is not a string nor a list of strings");
    };
  };

  lb_server;
};


#-----------------------------------------------------------------------------
# LB Logger configuration
#-----------------------------------------------------------------------------

variable WMS_LB_LOGGER_HOST ?= {
  host = undef;
  if ( is_string(WMS_LB_SERVER_HOST ) ) {
    host = WMS_LB_SERVER_HOST;
  } else {
    if ( is_list(WMS_LB_SERVER_HOST) && length(WMS_LB_SERVER_HOST) > 0 && is_string(WMS_LB_SERVER_HOST[0]) ) {
      host = WMS_LB_SERVER_HOST[0];
    } else {
      error("WMS_LB_SERVER_HOST is not a string nor a (non-empty) list.")
    };
  };
  if ( host==FULL_HOSTNAME ) {
    host = 'localhost';
  };

  host;
};

variable WMS_LB_LOGGER_PORT ?= 9002;
variable WMS_LB_LOGGER ?= WMS_LB_LOGGER_HOST + ':' + to_string(WMS_LB_LOGGER_PORT);


#-----------------------------------------------------------------------------
# Global Variables
#-----------------------------------------------------------------------------

variable WMS_SANDBOX_DIR ?= WMS_LOCATION_VAR + '/SandboxDir';
variable WMS_LOG_LEVEL_DEFAULT ?= 5;
variable GLITE_PR_TIMEOUT ?= 300;
variable WMS_QUERY_TIMEOUT ?= 300;


#-----------------------------------------------------------------------------
# glite_wms.conf: Job Controller variables
#-----------------------------------------------------------------------------

variable WMS_JC_LOG_LEVEL ?= WMS_LOG_LEVEL_DEFAULT;
variable WMS_JC_WORKDIR ?= WMS_LOCATION_VAR + '/jobcontrol';
# JC input queue format
variable WMS_JC_INPUT_TYPE = 'jobdir';
variable WMS_JC_INPUT ?= WMS_JC_WORKDIR + '/jobdir';
# Number of seconds that a job can wait in the condor queue to be matched
# before being resubmitted.
variable WMS_JC_MAX_TIME_CONDOR_MATCH ?= 1800;
# Maximum number of PRE scripts within the DAG that may be running a one time.
# It is the "-maxpre" parameter of the congdor_dagman command
variable WMS_JC_DAGAM_MAX_PRE ?= 10;

# JobController
'/software/components/wmslb/services/jc/name' = 'JobController';
'/software/components/wmslb/services/jc/workDirs' = list('jobcontrol',
                                                         'jobcontrol/condorio',
                                                         'jobcontrol/submit',
                                                    );
'/software/components/wmslb/services/jc/options/LogLevel' = WMS_JC_LOG_LEVEL;
'/software/components/wmslb/services/jc/options/LogFile' = WMS_LOCATION_LOG+'/jobcontroller_events.log';
'/software/components/wmslb/services/jc/options/InputType' = WMS_JC_INPUT_TYPE;
'/software/components/wmslb/services/jc/options/Input' = WMS_JC_INPUT;
'/software/components/wmslb/services/jc/options/MaximumTimeAllowedForCondorMatch' = WMS_JC_MAX_TIME_CONDOR_MATCH;
'/software/components/wmslb/services/jc/options/DagmanMaxPre' = WMS_JC_DAGAM_MAX_PRE;


#-----------------------------------------------------------------------------
# glite_wms.conf: Log Monitor variables
#-----------------------------------------------------------------------------

variable WMS_LM_LOG_LEVEL ?= WMS_LOG_LEVEL_DEFAULT;
# If set to true,  all files used to submit jobs to condor are removed when
# they are no more necessary. Set it to false only for debug purpose.
variable WMS_LM_REMOVE_JOB_FILES ?= true;

# LogMonitor
'/software/components/wmslb/services/lm/name' = 'LogMonitor';
'/software/components/wmslb/services/lm/workDirs' = list('logmonitor',
                                                         'logmonitor/CondorG.log',
                                                         'logmonitor/CondorG.log/recycle',
                                                         'logmonitor/internal',
                                                     );
'/software/components/wmslb/services/lm/options/LogLevel' = WMS_LM_LOG_LEVEL;
'/software/components/wmslb/services/lm/options/LogFile' = WMS_LOCATION_LOG+'/logmonitor_events.log';
'/software/components/wmslb/services/lm/options/ExternalLogFile' = WMS_LOCATION_LOG+'/logmonitor_external.log';
'/software/components/wmslb/services/lm/options/RemoveJobFiles' = WMS_LM_REMOVE_JOB_FILES;


#-----------------------------------------------------------------------------
# glite_wms.conf: Workload Manager variables
#-----------------------------------------------------------------------------

variable WMS_WM_WORKDIR ?= WMS_LOCATION_VAR + '/workload_manager';
# WM input queue format
variable WMS_WM_DISPATCHER_TYPE = 'jobdir';
variable WMS_WM_INPUT = WMS_WM_WORKDIR + '/jobdir';
variable WMS_WM_LOG_LEVEL ?= WMS_LOG_LEVEL_DEFAULT;
#variable WMS_WM_ISM_DUMP_RATE ?=  ;
# Number of worker threads in WM.
# Default value based on number of cores : 5 threads use 100% of a core.
variable WMS_WM_THREADS ?= 4 * get_num_of_cores();
# Enable WM recovery mode on startup to avoid duplicate requests on LB
variable WMS_WM_ENABLE_RECOVERY ?= true;
variable WMS_MAX_OUTPUT_SANDBOX_SIZE ?= -1;
variable WMS_WM_QUEUE_SIZE ?= 1000;
variable WMS_WM_USE_TCMALLOC ?= true;
# Decrease max time a job will be kept pending for retries after submission errors to a reasonnable value (2H).
# Interval between retries adjusted to allow several retries (MJ 12/11/08).
variable WMS_WM_EXPIRY_PERIOD ?= 7200;
variable WMS_WM_MATCH_RETRY_PERIOD ?= 1800;
variable WMS_WM_MAX_RETRY ?= 5;

'/software/components/wmslb/services/wm/name' = 'WorkloadManager';
'/software/components/wmslb/services/wm/workDirs' = list(WMS_WM_WORKDIR);
'/software/components/wmslb/services/wm/options/LogLevel' = WMS_WM_LOG_LEVEL;
'/software/components/wmslb/services/wm/options/LogFile' = WMS_LOCATION_LOG+'/workload_manager_events.log';
'/software/components/wmslb/services/wm/options/DispatcherType' = WMS_WM_DISPATCHER_TYPE;
'/software/components/wmslb/services/wm/options/Input' = WMS_WM_INPUT;
'/software/components/wmslb/services/wm/options/WorkerThreads' = WMS_WM_THREADS;
'/software/components/wmslb/services/wm/options/EnableRecovery' = WMS_WM_ENABLE_RECOVERY;
'/software/components/wmslb/services/wm/options/ExpiryPeriod' = WMS_WM_EXPIRY_PERIOD;
'/software/components/wmslb/services/wm/options/MatchRetryPeriod' = WMS_WM_MATCH_RETRY_PERIOD;
'/software/components/wmslb/services/wm/options/MaxRetryCount' = WMS_WM_MAX_RETRY;
'/software/components/wmslb/services/wm/options/IsmDump' = WMS_WM_WORKDIR+'/ismdump.fl';
'/software/components/wmslb/services/wm/options/MaxOutputSandboxSize' = WMS_MAX_OUTPUT_SANDBOX_SIZE;
# Cause threads for ISM to be created as needed rather than be picked in
# WorkerThreads pool
'/software/components/wmslb/services/wm/options/IsmThreads' = false;

# Number of jobs eligible to be processed by WM
'/software/components/wmslb/services/wm/options/QueueSize' = WMS_WM_QUEUE_SIZE;

# Define malloc implementation to use
'/software/components/wmslb/services/wm/options/RuntimeMalloc' = if ( WMS_WM_USE_TCMALLOC ) {
  '/usr/lib64/libjemalloc.so.1';
} else {
  '';
};
'/software/components/wmslb/services/wm/options/IsmIiLDAPCEFilterExt' = {
  filter = '"(|';
  foreach (i;vo;VOS) {
    voname=VO_INFO[vo]['name'];
    filter = filter + '(GlueCEAccessControlBaseRule=VO:'+voname+')(GlueCEAccessControlBaseRule=VOMS:/'+voname+'/*)';
  };
  filter = filter + ')"';

  filter;
};


#-----------------------------------------------------------------------------
# glite_wms.conf: Network Server variables
#-----------------------------------------------------------------------------

# Increase default BDII query timeout to ensure it never happens as there is a
# bug requiring. Workload Manager restart after such a timeout (MJ 12/11/08).
variable WMS_NS_II_TIMEOUT ?= 100;
variable WMS_NS_LOG_LEVEL ?= WMS_LOG_LEVEL_DEFAULT;
variable WMS_MAX_INPUT_SANDBOX_SIZE ?= 10000000;

# NetworServer
'/software/components/wmslb/services/ns/name' = 'NetworkServer';
'/software/components/wmslb/services/ns/workDirs' = list('networkserver');
'/software/components/wmslb/services/ns/options/LogLevel' = WMS_NS_LOG_LEVEL;
'/software/components/wmslb/services/ns/options/II_Contact' = TOP_BDII_HOST;
'/software/components/wmslb/services/ns/options/LogFile' = WMS_LOCATION_LOG+'/networkserver_events.log';
'/software/components/wmslb/services/ns/options/MaxInputSandboxSize' = WMS_MAX_INPUT_SANDBOX_SIZE;
'/software/components/wmslb/services/ns/options/SandboxStagingPath' = WMS_SANDBOX_DIR;
'/software/components/wmslb/services/ns/options/II_Timeout' = WMS_NS_II_TIMEOUT;


#-----------------------------------------------------------------------------
# glite_wms.conf: Workload Manager Proxy variables
#-----------------------------------------------------------------------------

variable WMS_WMPROXY_LOG_LEVEL ?= WMS_LOG_LEVEL_DEFAULT;
variable WMS_WMPROXY_APACHE_LOG_LEVEL ?= if ( WMS_WMPROXY_LOG_LEVEL <= 5 ) {
                                           'warn';
                                         } else {
                                           'debug';
                                         };
variable WMS_WMPROXY_MAX_SERVED_REQUESTS ?= 50;
variable WMS_MIN_PERUSAL_INTERVAL ?= 300;

variable WMS_WMPROXY_MAX_SERVED_REQUESTS ?= 50;
#variable WMS_DRAINED ?= false;
# WMS Load Monitoring script configuration
#variable WMS_LOAD_MONITOR_SCRIPT_CONTENTS ?= null;
variable WMS_LOAD_MONITOR_SCRIPT_NAME ?= '/usr/sbin/glite_wms_wmproxy_load_monitor';
variable WMS_LOAD_MONITOR_CPU_LOAD1 ?= 10;
variable WMS_LOAD_MONITOR_CPU_LOAD5 ?= 10;
variable WMS_LOAD_MONITOR_CPU_LOAD15 ?= 10;
variable WMS_LOAD_MONITOR_MEMORY_USAGE ?= 95;
variable WMS_LOAD_MONITOR_SWAP_USAGE ?= 90;
variable WMS_LOAD_MONITOR_FD_NUM ?= 500;
variable WMS_LOAD_MONITOR_DISK_USAGE ?= 95;
## Max number of unprocessed jobs in WM/ICE queues
variable WMS_LOAD_MONITOR_UNPROCESSED_JOBS_MAX ?= 500;
variable WMS_LOAD_MONITOR_FL_SIZE ?= 204800;
variable WMS_LOAD_MONITOR_FL_NUM ?= WMS_LOAD_MONITOR_UNPROCESSED_JOBS_MAX;
variable WMS_LOAD_MONITOR_JD_SIZE ?= 0;
variable WMS_LOAD_MONITOR_JD_NUM ?= WMS_LOAD_MONITOR_UNPROCESSED_JOBS_MAX;
variable WMS_LOAD_MONITOR_GRIDFTP_MAX ?= 150;

# WorkloadManagerProxy
'/software/components/wmslb/services/wmproxy/name' = 'WorkloadManagerProxy';
'/software/components/wmslb/services/wmproxy/workDirs' = list('wmproxy');
'/software/components/wmslb/services/wmproxy/confFiles' = nlist(
  escape(WMS_CONFIG_DIR+'/glite_wms_wmproxy_httpd.conf'), nlist('template','wmproxy_httpd.conf.template'),
);
#'/software/components/wmslb/services/wmproxy/drained' = WMS_DRAINED;
'/software/components/wmslb/services/wmproxy/options/MaxServedRequests' = WMS_WMPROXY_MAX_SERVED_REQUESTS;
'/software/components/wmslb/services/wmproxy/LoadMonitorScript/name' = WMS_LOAD_MONITOR_SCRIPT_NAME;
#'/software/components/wmslb/services/wmproxy/options/ApacheLogLevel' = WMS_WMPROXY_APACHE_LOG_LEVEL;
'/software/components/wmslb/services/wmproxy/options/LogLevel' = WMS_WMPROXY_LOG_LEVEL;
'/software/components/wmslb/services/wmproxy/options/LogFile' = WMS_LOCATION_LOG+'/wmproxy_events.log';
'/software/components/wmslb/services/wmproxy/options/LBLocalLogger' = WMS_LB_LOGGER;
'/software/components/wmslb/services/wmproxy/options/LBServer' = WMS_LB_SERVER;
#'/software/components/wmslb/services/wmproxy/options/ListMatchTimeout' = WMS_WMPROXY_LIST_MATCH_TIMEOUT;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdCPULoad1' = WMS_LOAD_MONITOR_CPU_LOAD1;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdCPULoad5' = WMS_LOAD_MONITOR_CPU_LOAD5;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdCPULoad15' = WMS_LOAD_MONITOR_CPU_LOAD15;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdMemUsage' = WMS_LOAD_MONITOR_MEMORY_USAGE;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdSwapUsage' = WMS_LOAD_MONITOR_SWAP_USAGE;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdFDNum' = WMS_LOAD_MONITOR_FD_NUM;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdDiskUsage' = WMS_LOAD_MONITOR_DISK_USAGE;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdFLSize' = WMS_LOAD_MONITOR_FL_SIZE;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdFLNum' = WMS_LOAD_MONITOR_FL_NUM;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdJDSize' = WMS_LOAD_MONITOR_JD_SIZE;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdJDNum' = WMS_LOAD_MONITOR_JD_NUM;
'/software/components/wmslb/services/wmproxy/options/LoadMonitor/ThresholdFTPConn' = WMS_LOAD_MONITOR_GRIDFTP_MAX;
'/software/components/wmslb/services/wmproxy/options/SandboxStagingPath' = WMS_SANDBOX_DIR;
#'/software/components/wmslb/services/wmproxy/options/SDJRequirements' = WMS_WMPROXY_SDJ_REQUIREMENT;
#
'/software/components/wmslb/services/wmproxy/options/MinPerusalTimeInterval' = WMS_MIN_PERUSAL_INTERVAL;


#-----------------------------------------------------------------------------
# glite_wms.conf: ICE variables
#-----------------------------------------------------------------------------

# WMS/ICE log level:
# (default 400) The verbosity level for log messages. Increasing
# verbosity levels are 0 (FATAL), 100 (ALERT), 200 (CRITICAL), 300
# (ERROR), 400 (WARN), 500 (NOTICE), 600 (INFO), 700 (DEBUG).
variable WMS_ICE_LOG_LEVEL ?= 400;
variable WMS_ICE_WORKDIR ?= WMS_LOCATION_VAR + '/ice';
# ICE specific parameters
# Lease process and listener must be disabled in WMS 3.1/2
variable WMS_ICE_LISTENER_ENABLED ?= false;
variable WMS_ICE_LEASE_UPDATER_ENABLED ?= false;
variable WMS_ICE_LEASE_DELTA_TIME ?= 0;
# ICE input queue format : use jobdir 
variable WMS_ICE_INPUT_TYPE = 'jobdir';
variable WMS_ICE_INPUT ?= WMS_ICE_WORKDIR + '/jobdir';

'/software/components/wmslb/services/ice/name' = 'ICE';
'/software/components/wmslb/services/ice/workDirs' = list('ice');
'/software/components/wmslb/services/ice/options/ice_log_level' = WMS_ICE_LOG_LEVEL;
'/software/components/wmslb/services/ice/options/logfile' = WMS_LOCATION_LOG+'/ice.log';
'/software/components/wmslb/services/ice/options/InputType' = WMS_ICE_INPUT_TYPE;
'/software/components/wmslb/services/ice/options/Input' = WMS_ICE_INPUT;
'/software/components/wmslb/services/ice/options/creamdelegation_url_postfix' = '/ce-cream/services/gridsite-delegation';
'/software/components/wmslb/services/ice/options/cream_url_postfix' = '/ce-cream/services/CREAM2';
'/software/components/wmslb/services/ice/options/cemon_url_postfix' = '/ce-monitor/services/CEMonitor';
'/software/components/wmslb/services/ice/options/lease_delta_time' = WMS_ICE_LEASE_DELTA_TIME;
'/software/components/wmslb/services/ice/options/start_lease_updater' = WMS_ICE_LEASE_UPDATER_ENABLED;
'/software/components/wmslb/services/ice/options/start_listener' = WMS_ICE_LISTENER_ENABLED;


#-----------------------------------------------------------------------------
# glite_wms.conf: Wms Client variables
#-----------------------------------------------------------------------------

'/software/components/wmslb/services/wmsclient/name' = 'WmsClient';

# Configure WMS to use LB proxy by default.
# This will be reset by LB configuration (or already defined if LB is configured first),
# if it is done on the same machine.
variable WMS_USE_LB_PROXY ?= true;

# Use same variables as in LB and default assignment to ensure consistency if both WMS and LB
# run on the same machine, whichever is included first.
variable WMS_CERT_DIR ?= GLITE_USER_HOME + "/.certs" ;
variable WMS_HOST_KEY ?= WMS_CERT_DIR + "/" + "hostkey.pem";
variable WMS_HOST_CERT ?= WMS_CERT_DIR + "/" + "hostcert.pem";


#-----------------------------------------------------------------------------
# GridFTP Configuration
#-----------------------------------------------------------------------------

# Don't try to modify it as it is hardcoded in some scripts. See GGUS #34890
variable WMS_X509_PROXY ?= EMI_LOCATION_VAR + '/glite/wms.proxy';

include { 'components/chkconfig/config' };
"/software/components/chkconfig/service/globus-gridftp/on" = ""; 
"/software/components/chkconfig/service/globus-gridftp/startstop" = true; 

include { 'common/globus/sysconfig' };
#"/software/components/sysconfig/files/globus/LCMAPS_DB_FILE" = "/etc/lcmaps/lcmaps.db.gridftp";
'/software/components/sysconfig/files/globus/epilogue' = {
  epilogue = '';
  if (is_defined(SELF)) {
    epilogue = epilogue + SELF + "\n";
  };
  epilogue = epilogue + 'export LCMAPS_DB_FILE=/etc/lcmaps/lcmaps.db.gridftp';

  epilogue;
};

# Define proxy file name as appropriate for WMS
'/system/glite/config/GLITE_X509_PROXY' = WMS_X509_PROXY;

## Define some required environment variables and configure WMS services
#
include { 'components/wmslb/config' };
'/software/components/wmslb/dependencies/pre' = push('accounts','profile');
# Run glitestartup component after any wmslb config change to handle service restart
'/software/components/wmslb/dependencies/post' = push('glitestartup');
'/software/components/wmslb/confFile' = EMI_LOCATION_ETC + '/glite-wms/glite_wms.conf';

## Default parent for workDirs specified with a relative path
'/software/components/wmslb/workDirDefaultParent' = WMS_LOCATION_VAR;

#-----------------------------------------------------------------------------
# Environment Settings
#-----------------------------------------------------------------------------
# Delete envScript property to prevent wmslb updating the profile script. This
# will be done by ncm-profile but env resource is still defined for ncm-wmslb
# to allow schema validation.
'/software/components/wmslb/envScript' = null;
'/software/components/wmslb/env/GLITE_LOCATION' = GLITE_LOCATION;
'/software/components/wmslb/env/GLITE_LOCATION_LOG' = GLITE_LOCATION_LOG;
'/software/components/wmslb/env/GLITE_LOCATION_TMP' = GLITE_LOCATION_TMP;
'/software/components/wmslb/env/GLITE_LOCATION_VAR' = GLITE_LOCATION_VAR;
'/software/components/wmslb/env/GLITE_WMS_LOCATION_VAR' = WMS_LOCATION_VAR;
'/software/components/wmslb/env/GLITE_WMS_TMP' = WMS_LOCATION_TMP;
'/software/components/wmslb/env/GLITE_WMS_USER' = GLITE_USER;
'/software/components/wmslb/env/GLITE_WMS_GROUP' = GLITE_GROUP;
'/software/components/wmslb/env/GLITE_WMS_QUERY_TIMEOUT' = WMS_QUERY_TIMEOUT;
'/software/components/wmslb/env/GLITE_WMS_WMPROXY_MAX_SERVED_REQUESTS' = WMS_WMPROXY_MAX_SERVED_REQUESTS;
'/software/components/wmslb/env/GLITE_PR_TIMEOUT' = GLITE_PR_TIMEOUT;
'/software/components/wmslb/env/GLITE_SD_PLUGIN' = 'bdii';
'/software/components/wmslb/env/GLITE_HOST_KEY' = WMS_HOST_KEY;
'/software/components/wmslb/env/GLITE_HOST_CERT' = WMS_HOST_CERT;
'/software/components/wmslb/env/GLOBUS_LOCATION' = GLOBUS_LOCATION;
'/software/components/wmslb/env/CONDORG_INSTALL_PATH' ?= CONDOR_INSTALL_PATH;
'/software/components/wmslb/env/CONDOR_CONFIG' ?= CONDOR_CONFIG_FILE;
'/software/components/wmslb/env/GLITE_USER' ?= GLITE_USER;
'/software/components/wmslb/env/X509_CERT_DIR' ?= SITE_DEF_CERTDIR;
'/software/components/wmslb/env/X509_VOMS_DIR' ?= SITE_DEF_VOMSDIR;
'/software/components/wmslb/env/MYPROXY_TCP_PORT_RANGE' ?= GLOBUS_TCP_PORT_RANGE;
'/software/components/wmslb/env/WMS_JOBWRAPPER_TEMPLATE' ?= '/usr/share/glite-wms';
'/software/components/wmslb/env/WMS_LOCATION_USR' ?= '/usr';
'/software/components/wmslb/env/WMS_LOCATION_BIN' ?= '/usr/bin';
'/software/components/wmslb/env/WMS_LOCATION_ETC' ?= WMS_LOCATION_ETC;
'/software/components/wmslb/env/WMS_LOCATION_LIBEXEC' ?= '/usr/libexec';
'/software/components/wmslb/env/WMS_LOCATION_LOG' ?= WMS_LOCATION_LOG;
'/software/components/wmslb/env/WMS_LOCATION_SBIN' ?= '/usr/sbin';
'/software/components/wmslb/env/WMS_LOCATION_TMP' ?= WMS_LOCATION_TMP;
'/software/components/wmslb/env/WMS_LOCATION_VAR' ?= WMS_LOCATION_VAR;
'/software/components/wmslb/env/GLITE_WMS_CONFIG_DIR' ?= WMS_CONFIG_DIR;
'/software/components/wmslb/env/GLITE_LB_TYPE' ?= GLITE_LB_TYPE;
'/software/components/wmslb/env/LCG_GFAL_INFOSYS' ?= {
  if(is_defined(TOP_BDII_LIST)) {
    TOP_BDII_LIST;
  } else {
    TOP_BDII_HOST+':'+to_string(BDII_PORT);
  };
};

variable WMS_ENV_PATHS_NLIST = value('/software/components/wmslb/env/');
'/software/components/profile' = component_profile_add_env(GLITE_GRID_ENV_PROFILE, WMS_ENV_PATHS_NLIST);


# Bug fix https://ggus.eu/tech/ticket_show.php?ticket=87802
'/software/components/profile' = component_profile_add_env(GLITE_GRID_ENV_PROFILE, nlist('ICE_DISABLE_DEREGISTER', 1));


'/software/components/wmslb/common/LBProxy' = WMS_USE_LB_PROXY;

# Specific WMS directories
variable WMS_DIRECTORIES = list(
  WMS_LOCATION_LOG,
  WMS_LOCATION_VAR + "/fastcgi",
  WMS_LOCATION_VAR + "/ice",
  WMS_LOCATION_VAR + "/ice/jobdir",
  WMS_LOCATION_VAR + "/ice/persist_dir",
  WMS_LOCATION_VAR + "/jobcontrol",
  WMS_LOCATION_VAR + "/jobcontrol/condorio",
  WMS_LOCATION_VAR + "/jobcontrol/jobdir",
  WMS_LOCATION_VAR + "/jobcontrol/submit",
  WMS_LOCATION_VAR + "/logging",
  WMS_LOCATION_VAR + "/logmonitor",
  WMS_LOCATION_VAR + "/logmonitor/CondorG.log",
  WMS_LOCATION_VAR + "/logmonitor/CondorG.log/recycle",
  WMS_LOCATION_VAR + "/logmonitor/internal",
  WMS_LOCATION_VAR + "/networkserver",
  WMS_LOCATION_VAR + "/wmproxy",
  WMS_LOCATION_VAR + "/workload_manager",
  WMS_LOCATION_VAR + "/workload_manager/jobdir",
  GLITE_LOCATION_VAR + "/wmproxy",
);

include { 'components/dirperm/config' };

'/software/components/dirperm/paths' = {
  foreach(k;directory;WMS_DIRECTORIES) {
    SELF[length(SELF)] = nlist(
      'path', directory,
      'owner' , GLITE_USER+':'+GLITE_GROUP,
      'perm', '0755',
      'type', 'd',
    );
  };
  SELF[length(SELF)] = nlist(
    'path', WMS_LOCATION_VAR + "/proxycache",
    'owner', GLITE_USER+':'+GLITE_GROUP,
    'perm', '0771',
    'type', 'd'
  );
  SELF[length(SELF)] = nlist(
    'path', WMS_SANDBOX_DIR,
    'owner', GLITE_USER+':'+GLITE_GROUP,
    'perm', '0773',
    'type', 'd'
  );
  # hardcoded in the init script
  SELF[length(SELF)] = nlist(
    'path', "/var/glite/spool/glite-renewd",
    'owner', GLITE_USER+':'+GLITE_GROUP,
    'perm', '0773',
    'type', 'd'
  );

  SELF;
};

# Fix a RPM error
#'/software/components/dirperm/paths' = push(
#  nlist(
#    'path', WMS_LOCATION_SBIN+'/glite_wms_wmproxy_load_monitor',
#    'owner', 'root:root',
#    'perm', '0755',
#    'type','f'
#  ),
#);
#-----------------------------------------------------------------------------
# gLite startup script
#-----------------------------------------------------------------------------

include { 'components/glitestartup/config' };

"/software/components/glitestartup/configFile" = EMI_LOCATION_ETC + "/gLiteservices";
'/software/components/glitestartup/dependencies/pre' = glitestartup_add_dependency(list('accounts','dirperm','mysql','profile','wmslb'));
'/software/components/glitestartup/restartEnv' = push(GLITE_ENV_SCRIPT_DEFAULT);
'/software/components/glitestartup/scriptPaths' = list("/etc/init.d");
'/software/components/glitestartup/restartServices' = true;

# This line is necessary because of PAN bug (see LCGQWG ticket #154)
'/software/components/glitestartup/services' = {
  if ( exists(SELF) && is_defined(SELF) ) {
    SELF;
  } else {
    nlist();
  };
};

'/software/components/glitestartup/services' = {  
  services = SELF;

  foreach (i;service;WMS_SERVICES) {
    service = 'glite-wms-' + service;
    services = glitestartup_mod_service(service);
  };
  
  foreach (i;service;WMS_AUX_SERVICES) {
    service = 'glite-' + service;
    services = glitestartup_mod_service(service);
  };
  
  if ( is_defined(services) && (length(services) > 0) ) {
    services;
  } else {
    null;
  };
};


#-----------------------------------------------------------------------------
# MySQL Configuration
#-----------------------------------------------------------------------------

include { 'components/mysql/config' };

'/software/components/mysql/servers/' = {
  SELF[WMS_MYSQL_SERVER]['adminuser'] = LB_MYSQL_ADMINUSER;
  SELF[WMS_MYSQL_SERVER]['adminpwd'] = LB_MYSQL_ADMINPWD;
  SELF[WMS_MYSQL_SERVER]['options']['max_allowed_packet'] = '17M';
  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[WMS_LBPROXY_DB_NAME]['server'] = WMS_MYSQL_SERVER;
  SELF[WMS_LBPROXY_DB_NAME]['initScript']['file'] = WMS_LBPROXY_DB_INIT_SCRIPT;
  # init script for LB doesn't have the if exists tests..
  SELF[WMS_LBPROXY_DB_NAME]['initOnce'] = true;
  SELF[WMS_LBPROXY_DB_NAME]['users'][WMS_DB_USER] = nlist('password', WMS_DB_PWD,
                                                          'rights', list('ALL PRIVILEGES'),
                                                    );
  SELF[WMS_LBPROXY_DB_NAME]['tableOptions']['short_fields']['MAX_ROWS'] = '1000000000';
  SELF[WMS_LBPROXY_DB_NAME]['tableOptions']['long_fields']['MAX_ROWS'] = '55000000';
  SELF[WMS_LBPROXY_DB_NAME]['tableOptions']['events']['MAX_ROWS'] = '175000000';
  SELF[WMS_LBPROXY_DB_NAME]['tableOptions']['states']['MAX_ROWS'] = '9500000';

  SELF;
};


##correct a sysconfig glite file that doesn't export 2 variables
## this is more probably a gridftp startup script bug, which sources
## the file but doesnt export the variables it needs
#'/software/components/sysconfig/files/glite/epilogue' = {
#	tmp = 'export GRIDMAP="' + SITE_DEF_GRIDMAP + '"' + "\n";
#	tmp = tmp + 'export GRIDMAPDIR="' + SITE_DEF_GRIDMAPDIR + '"' + "\n";
#	if ( exists(SELF) && is_defined(SELF) ) {
#		tmp=SELF + "\n" + tmp;
#	};
#	tmp;
#};
#
#
# Configure grid ACLs
include { 'components/gacl/config' };
'/software/components/gacl/aclFile' = WMS_GACL_FILE;


## Configure logrotate for WMS log files
#include { 'components/altlogrotate/config' };
#"/software/components/altlogrotate/entries/httpd-wmproxy-access" = 
#  nlist("pattern", "/var/log/glite/httpd-wmproxy-access*.log",
#        "compress", true,
#        "missingok", true,
#        "frequency", "weekly",
#        "copytruncate", true,
#        "ifempty", true,
#        "rotate", 5);
#"/software/components/altlogrotate/entries/httpd-wmproxy-errors" = 
#  nlist("pattern", "/var/log/glite/httpd-wmproxy-errors*.log",
#        "compress", true,
#        "missingok", true,
#        "frequency", "weekly",
#        "copytruncate", true,
#        "ifempty", true,
#        "rotate", 5);
#
#
# Configure WMS cron jobs
include { 'common/wms/crons' };


## Script to monitor ISM updates because of a bug that may require a service restart (GGUS #42999)
## FIXME: remove when bug is fixed.
#variable WMS_MONITOR_ISM ?= true;
#variable WMS_MONITOR_ISM_INCLUDE ?= if ( WMS_MONITOR_ISM ) {
#                                      if_exists('common/wms/ism_monitoring');
#                                    } else {
#                                      undef;
#                                    };
#include { WMS_MONITOR_ISM_INCLUDE };
#                                    
#
## Fixed version of glite-wms-purgeStorage.sh (GGUS #43206)
## FIXME: remove when bug is fixed.
#variable WMS_PURGE_STORAGE_FIX ?= true;
#variable WMS_PURGE_STORAGE_FIX_INCLUDE ?= if ( WMS_PURGE_STORAGE_FIX ) {
#                                      if_exists('common/wms/fix_purge_storage');
#                                    } else {
#                                      undef;
#                                    };
#include { WMS_PURGE_STORAGE_FIX_INCLUDE };

# Temporary fix
"/software/components/symlink/links" = {
  SELF[length(SELF)] =   nlist("name", WMS_LOCATION_VAR + "/spool/glite-renewd",
                               "target", "/var/glite/spool/glite-renewd",
                               "replace", nlist("all","yes"),
                              );
  SELF;
};

