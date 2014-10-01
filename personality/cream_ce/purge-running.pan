unique template personality/cream_ce/purge-running;

variable CREAM_PURGE_RUNNING_DATE ?= '5';
variable CREAM_PURGE_IDLE_DATE ?= '10';

include { 'components/cron/config' };

'/software/components/cron/entries'=push(
  nlist(
    'command',   'env '+
                 'CATALINA_HOME=/usr/share/tomcat6 '+
                format('/usr/sbin/JobDBAdminPurger.sh -s RUNNING,%s:REALLY-RUNNING,%s:IDLE,%s',CREAM_PURGE_RUNNING_DATE,CREAM_PURGE_RUNNING_DATE,CREAM_PURGE_IDLE_DATE),
    'frequency', '0 5 * * *',
    'name',      'purgeCreamRunning',
    'user',      'root',
  ),  
);

