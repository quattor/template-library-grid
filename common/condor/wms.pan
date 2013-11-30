# Configuration specific to gLite WMS

unique template common/condor/wms;

variable WMS_CONDORC_LOG_DIR ?= '/var/tmp';

#"/software/components/condorconfig/COLLECTOR_HOST" = "$(FULL_HOSTNAME)";
#"/software/components/condorconfig/DAEMON_LIST" = "MASTER, SCHEDD, COLLECTOR, NEGOTIATOR";
#"/software/components/condorconfig/GLITE_CONDORC_DEBUG_LEVEL" = "1" ;
#"/software/components/condorconfig/GLITE_CONDORC_LOG_DIR" = WMS_CONDORC_LOG_DIR ;

#EMI
#"/software/components/condorconfig/GRID_MONITOR" = "/usr/sbin/grid_monitor.sh";
#"/software/components/condorconfig/GT2_GAHP" = "/usr/sbin/gahp_server";
