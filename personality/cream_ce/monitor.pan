unique template personality/cream_ce/monitor;

#
# Not yet usable as pan can't bind
# to a variable
#
variable CREAM_MONITORING_BASE_DIR  ?= "/etc/glite-cream-ce-utils";
variable CREAM_MONITORING_CONF_FILE ?= "glite_cream_load_monitor.conf";

#############################
# All monitoring parameter  #s
# -1 means no limit         #
#############################
variable CREAM_MONITORING_LOAD1       ?=  40;
variable CREAM_MONITORING_LOAD5       ?=  40;
variable CREAM_MONITORING_LOAD15      ?=  20;
variable CREAM_MONITORING_MEMUSAGE    ?=  95;
variable CREAM_MONITORING_SWAPUSAGE   ?=  95;
variable CREAM_MONITORING_FDNUM       ?= 500;
variable CREAM_MONITORING_DISKUSAGE   ?=  95;
variable CREAM_MONITORING_FTPCONN     ?= 800;
variable CREAM_MONITORING_FDTOMCAT    ?= 800;
variable CREAM_MONITORING_ACTIVE_JOBS ?=  -1;
variable CREAM_MONITORING_PENDING_CMD ?=  -1;

include { 'components/metaconfig/config' };

# Define type for cream monitoring

type cream_monitoring = {
  "Load1"       : long
  "Load5"       : long
  "Load15"      : long
  "MemUsage"    : long
  "SwapUsage"   : long
  "FDNum"       : long
  "DiskUsage"   : long
  "FTPConn"     : long
  "FDTomcatNum" : long
  "ActiveJobs"  : long
  "PendingCmds" : long
};

bind '/software/components/metaconfig/services/{/etc/glite-ce-cream-ce-utils/glite_cream_load_monitor.conf}/contents' = cream_monitoring;

prefix '/software/components/metaconfig/services/{/etc/glite-ce-cream-ce-utils/glite_cream_load_monitor.conf}';

'module' = 'tiny';
'mode'   = 0644;
'owner'  = 'root';
'group'  = 'root';

'contents/Load1'       = CREAM_MONITORING_LOAD1;
'contents/Load5'       = CREAM_MONITORING_LOAD5;
'contents/Load15'      = CREAM_MONITORING_LOAD15;
'contents/MemUsage'    = CREAM_MONITORING_MEMUSAGE;
'contents/SwapUsage'   = CREAM_MONITORING_SWAPUSAGE;
'contents/FDNum'       = CREAM_MONITORING_FDNUM;
'contents/DiskUsage'   = CREAM_MONITORING_DISKUSAGE;
'contents/FTPConn'     = CREAM_MONITORING_FTPCONN;
'contents/FDTomcatNum' = CREAM_MONITORING_FDTOMCAT;
'contents/ActiveJobs'  = CREAM_MONITORING_ACTIVE_JOBS;
'contents/PendingCmds' = CREAM_MONITORING_PENDING_CMD;

