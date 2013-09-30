# Template to install a cron job to monitor ISM updates because of a bug that may require
# a service restart (GGUS #42999)

unique template common/wms/ism_monitoring;

variable WMS_MONITOR_ISM_SCRIPT ?= GLITE_LOCATION + '/etc/glite-wms-ism-monitoring';

variable WMS_MONITOR_ISM_CONTENTS ?= <<EOF;
#!/bin/sh

failure_threshold=3
wm_log=/var/log/glite/wms/workload_manager_events.log

num_failures=`grep fetch_bdii_ce_info ${wm_log} |tail -n ${failure_threshold}|grep 'Timed out'|wc -l`

if [ ${num_failures} -ge ${failure_threshold} ]
then
  echo "ISM update failure. Restarting workload manager..."
  /opt/glite/etc/init.d/glite-wms-wm restart
fi

exit ${num_failures}
EOF


include { 'components/filecopy/config' };
'/software/components/filecopy/services' = {
  SELF[escape(WMS_MONITOR_ISM_SCRIPT)] =  nlist('config', WMS_MONITOR_ISM_CONTENTS,
                                        'owner', 'root:root',
                                        'perms', '0755'
                                       );
  SELF;
};


# Run very frequently to ensure a prompt reaction if the problem occurs
"/software/components/cron/entries" = 
  push(nlist(
    "name","glite-wms-ism-monitoring",
    "user","root",
    "frequency", "0 */2 * * *", #harmfull monitoring script : lower frequence, see https://ggus.eu/ws/ticket_info.php?ticket=76819
    "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + WMS_PROFILE_SCRIPT + ";"+
                     WMS_MONITOR_ISM_SCRIPT,
           ));

"/software/components/altlogrotate/entries/glite-wms-ism-monitoring" = 
  nlist("pattern", "/var/log/glite-wms-ism-monitoring",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

