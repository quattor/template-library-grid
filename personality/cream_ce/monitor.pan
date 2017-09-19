unique template personality/cream_ce/monitor;

#
# Not yet usable as pan can't bind
# to a variable
#
variable CREAM_MONITORING_BASE_DIR  ?= "/etc/glite-ce-cream-utils";
variable CREAM_MONITORING_CONF_FILE ?= CREAM_MONITORING_BASE_DIR + "/glite_cream_load_monitor.conf";

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

include 'components/metaconfig/config';

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

bind '/software/components/metaconfig/services/{${CREAM_MONITORING_CONF_FILE}}/contents' = cream_monitoring;

'/software/components/metaconfig/services' = merge(SELF, dict(
    escape(CREAM_MONITORING_CONF_FILE), dict(
        'module', 'tiny',
        'mode', 0644,
        'owner', 'root',
        'group', 'root',
        'contents', dict(
            'Load1', CREAM_MONITORING_LOAD1,
            'Load5', CREAM_MONITORING_LOAD5,
            'Load15', CREAM_MONITORING_LOAD15,
            'MemUsage', CREAM_MONITORING_MEMUSAGE,
            'SwapUsage', CREAM_MONITORING_SWAPUSAGE,
            'FDNum', CREAM_MONITORING_FDNUM,
            'DiskUsage', CREAM_MONITORING_DISKUSAGE,
            'FTPConn', CREAM_MONITORING_FTPCONN,
            'FDTomcatNum', CREAM_MONITORING_FDTOMCAT,
            'ActiveJobs', CREAM_MONITORING_ACTIVE_JOBS,
            'PendingCmds', CREAM_MONITORING_PENDING_CMD,
        ),
    ),
));
