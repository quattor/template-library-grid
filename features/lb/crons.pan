
unique template features/lb/crons;

variable LB_PROFILE_SCRIPT ?= '/etc/profile.d/grid-env.sh';

include { 'components/cron/config' };
include { 'components/altlogrotate/config' };

# glite-wms-purge storage is run only if needed Monday-Saturday and unconditonnally on Sunday
# This cron also takes care of renewing proxy used by WMS services.
"/software/components/cron/entries" =
  push(nlist(
    "name","glite-lb-export",
    "user",GLITE_USER,
    "frequency", "1 1 * * *",
    "env", nlist('PATH', '"/sbin:/bin:/usr/sbin:/usr/bin"',
                 'GLITE_LB_EXPORT_BKSERVER', FULL_HOSTNAME,
                 'GLITE_LB_EXPORT_ENABLED', 'false',
                 'GLITE_LB_EXPORT_PURGE_ARGS', '"--cleared 2d --aborted 15d --cancelled 15d --other 60d -s"',
                ),
    "command", ". " + LB_PROFILE_SCRIPT + ";"+
               GLITE_LOCATION+"/sbin/glite-lb-export.sh"
            ));


# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------
include { 'components/altlogrotate/config' };

"/software/components/altlogrotate/entries/glite-lb-export" =
  nlist("pattern", "/var/log/glite-lb-export.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 4);


