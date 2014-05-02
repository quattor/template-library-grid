
unique template features/globus/gatekeeper;

variable GK_PORT ?= 2119;

# ---------------------------------------------------------------------------- 
# chkconfig
# ---------------------------------------------------------------------------- 
include { 'components/chkconfig/config' };

"/software/components/chkconfig/service/globus-gatekeeper/on" = ""; 


# ---------------------------------------------------------------------------- 
# accounts
# ---------------------------------------------------------------------------- 
include { 'users/gatekeeper' };


# ---------------------------------------------------------------------------- 
# iptables
# ---------------------------------------------------------------------------- 
include { 'components/iptables/config' };

# Inbound port(s).
"/software/components/iptables/filter/rules" = push(
  nlist("command", "-A",
        "chain", "input",
        "match", "state",
        "state", "NEW",
        "protocol", "tcp",
        "dst_port", to_string(GK_PORT),
        "target", "accept"));

# Outbound port(s).


# ---------------------------------------------------------------------------- 
# etcservices
# ---------------------------------------------------------------------------- 
include { 'components/etcservices/config' };

"/software/components/etcservices/entries" = 
  push("gatekeeper "+to_string(GK_PORT)+"/tcp");


# ---------------------------------------------------------------------------- 
# cron
# ---------------------------------------------------------------------------- 
#include { 'components/cron/config' };


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
include { 'components/altlogrotate/config' }; 

"/software/components/altlogrotate/entries/globus-gatekeeper" = 
  nlist("pattern", "/var/log/globus-gatekeeper.log",
        "compress", false,
        "copy", true,
        "rotate", 1,
	"scripts", nlist(
          "prerotate","killall -s USR1 "+
                      "-e "+GLOBUS_LOCATION+"/sbin/globus-gatekeeper",
          "postrotate", "find /var/log/globus-gatekeeper.log.20????????????.*[0-9] -mtime +7 -exec gzip {} \\;"));


# ---------------------------------------------------------------------------- 
# globuscfg
# ---------------------------------------------------------------------------- 
include { 'components/globuscfg/config' };

include { 'features/globus/base' };

# Ensure that the gatekeeper is restarted when necessary. 
"/software/components/globuscfg/services" = push("globus-gatekeeper");

# Setup necessary parameters for gatekeeper.
"/software/components/globuscfg/gatekeeper/globus_gatekeeper" = 
   EDG_LOCATION+"/sbin/edg-gatekeeper";

# Extra gatekeeper options for LCAS and LCMAPS. 
"/software/components/globuscfg/gatekeeper/extra_options" = 
  '"-lcas_db_file lcas.db '+
  '-lcas_etc_dir '+EDG_LOCATION+'/etc/lcas/ '+
  '-lcasmod_dir '+EDG_LOCATION+'/lib/lcas/ '+
  '-lcmaps_db_file lcmaps.db '+
  '-lcmaps_etc_dir '+EDG_LOCATION+'/etc/lcmaps '+
  '-lcmapsmod_dir '+EDG_LOCATION+'/lib/lcmaps"';

# Location of the log file. 
"/software/components/globuscfg/gatekeeper/logfile" = 
  "/var/log/globus-gatekeeper.log";

# Set LRMS system in site-cfg.  If you want a fork job manager, you must 
# list it.  The default job manager will be the first one listed. 
"/software/components/globuscfg/gatekeeper/jobmanagers" = list(
  nlist("recordname","fork",
        "job_manager","globus-job-manager")
);
"/software/components/globuscfg/gatekeeper/jobmanagers" = if ( exists(CE_BATCH_SYS) && is_defined(CE_BATCH_SYS) ) {
                                                            push(nlist("recordname",CE_BATCH_SYS,
                                                                        "type",CE_JM_TYPE));
                                                          } else {
                                                            return(SELF);
                                                          };

