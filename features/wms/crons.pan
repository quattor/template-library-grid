
unique template features/wms/crons;

variable WMS_CREATEPROXY_LOG ?= 'glite-wms-create-host-proxy.log';
variable WMS_PURGER_LOG ?= 'glite-wms-purger.log';
variable WMS_PURGE_PROXYCACHE_LOG ?= 'glite-wms-wmproxy-purge-proxycache.log';
variable WMS_PURGE_PROXYCACHE_KEYS_LOG ?= 'glite-wms-wmproxy-purge-proxycache-keys.log';
variable WMS_CRON_PURGESTORAGE_PARTIAL_INTERVAL ?= 6;
variable WMS_CRON_PURGESTORAGE_PARTIAL_TARGET ?= if ( is_null(SELF) ) {
                                                   SELF;
                                                 } else {
                                                   40;
                                                 };

# Minimum number of days a file is kept before being eligible to purging. Default = 7 days
variable WMS_CRON_PURGESTORAGE_AGE_THRESHOLD ?= 1296000;
# Minimum number of days a file is kept before being eligible to partial purging. Default = WMS_CRON_PURGESTORAGE_AGE_THRESHOLD / 2
variable WMS_CRON_PURGESTORAGE_PARTIAL_AGE_THRESHOLD ?= WMS_CRON_PURGESTORAGE_AGE_THRESHOLD / 2;

include { 'components/cron/config' };
include { 'components/altlogrotate/config' };

"/software/components/cron/entries" =
  push(
    nlist(
      "name", "glite-wms-check-daemons",
      "user", "root",
      "frequency", "*/5 * * * *",
      "command",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + GLITE_GRID_ENV_PROFILE + ";" +
        GLITE_LOCATION + "/libexec/glite-wms-check-daemons.sh",
     )
  );

# Add a cron job to create host proxy
"/software/components/cron/entries" =
  push(
    nlist(
      "name", "glite-wms-create-host-proxy",
      "user", GLITE_USER,
      "frequency", "AUTO */6 * * *",
      "command",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + GLITE_GRID_ENV_PROFILE + ";" +
        "/usr/sbin/glite-wms-create-proxy.sh " + WMS_X509_PROXY + " " +
        WMS_LOCATION_LOG + "/" + WMS_CREATEPROXY_LOG + ";"
    )
  );

# Execute the 'purger' command at every day except on Sunday with a frequency of six hours
# glite-wms-purge storage is run only if needed Monday-Saturday and unconditonnally on Sunday
# This cron also takes care of renewing proxy used by WMS services.
variable WMS_CRON_PARTIAL_TARGET_OPTION = if ( is_defined(WMS_CRON_PURGESTORAGE_PARTIAL_TARGET) ) {
                                            ' -a '+to_string(WMS_CRON_PURGESTORAGE_PARTIAL_TARGET);
                                          } else {
                                            '';
                                          };
"/software/components/cron/entries" =
  push(
    nlist(
      "name", "glite-wms-purgestorage-partial",
      "user", GLITE_USER,
      "frequency", "AUTO */" + to_string(WMS_CRON_PURGESTORAGE_PARTIAL_INTERVAL) + " * * 1-6",
      "command",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + GLITE_GRID_ENV_PROFILE+";" +
        GLITE_LOCATION + "/sbin/glite-wms-purgeStorage.sh -l " +
        WMS_LOCATION_LOG + "/" + WMS_PURGER_LOG +
        " -p " + WMS_SANDBOX_DIR + " -t " + to_string(WMS_CRON_PURGESTORAGE_PARTIAL_AGE_THRESHOLD)+
        WMS_CRON_PARTIAL_TARGET_OPTION,
    )
  );

# Execute the 'purger' command on each Sunday (sun) forcing removal of dag nodes,
# orphan dag nodes without performing any status checking (threshold of 2 weeks).
"/software/components/cron/entries" =
  push(
    nlist(
      "name", "glite-wms-purgestorage-full",
      "user", GLITE_USER,
      "frequency", "AUTO 1 * * 0",
      "command",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + GLITE_GRID_ENV_PROFILE + ";" +
        GLITE_LOCATION+"/sbin/glite-wms-purgeStorage.sh -l " +
        WMS_LOCATION_LOG+"/"+WMS_PURGER_LOG + " -p " + WMS_SANDBOX_DIR +
        " -o -s -t " + to_string(WMS_CRON_PURGESTORAGE_AGE_THRESHOLD),
    )
  );

"/software/components/cron/entries" =
  push(
    nlist(
      "name", "glite-wms-wmproxy-purge-proxycache",
      "user", "root",
      "frequency", "AUTO */6 * * *",
      "command",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + GLITE_GRID_ENV_PROFILE + ";" +
        GLITE_LOCATION + "/bin/glite-wms-wmproxy-purge-proxycache " +
        EMI_LOCATION_VAR + "/proxycache >> " +
        WMS_LOCATION_LOG + "/" + WMS_PURGE_PROXYCACHE_LOG,
    )
  );

"/software/components/cron/entries" =
  push(
    nlist(
      "name", "glite-wms-wmproxy-purge-proxycache_keys",
      "user", "root",
      "frequency", "AUTO */2 * * *",
      "command",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + GLITE_GRID_ENV_PROFILE + ";" +
        GLITE_LOCATION + "/bin/glite-wms-wmproxy-purge-proxycache_keys >> " +
        WMS_LOCATION_LOG + "/" + WMS_PURGE_PROXYCACHE_KEYS_LOG,
    )
  );

# Add a cron job to restart WMProxy everyday to ensure it is using the last CRL
"/software/components/cron/entries" =
  push(
    nlist(
      "name", "glite-wms-wmproxy-restart",
      "user", "root",
      "frequency", "AUTO 0 * * *",
      "command",
        "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . " + GLITE_GRID_ENV_PROFILE + ";" +
        "/etc/init.d/glite-wms-wmproxy graceful",
    )
  );

# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------

include { 'components/altlogrotate/config' };

"/software/components/altlogrotate/entries/glite-wms-check-daemons" =
  nlist("pattern", WMS_LOCATION_LOG + "/glite-wms-check-daemons.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-create-host-proxy" =
  nlist("pattern", WMS_LOCATION_LOG+"/glite-wms-create-host-proxy.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "monthly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-create-host-proxy.log" =
  nlist("pattern", WMS_LOCATION_LOG+"/"+WMS_CREATEPROXY_LOG,
        "compress", true,
        "missingok", true,
        "frequency", "monthly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-purgestorage-partial" =
  nlist("pattern", WMS_LOCATION_LOG+'/glite-wms-purgestorage-partial.ncm-cron.log',
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-purger.log" =
  nlist("pattern", WMS_LOCATION_LOG+'/'+WMS_PURGER_LOG,
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-purgestorage-full" =
  nlist("pattern", WMS_LOCATION_LOG+'/glite-wms-purgestorage-full.ncm-cron.log',
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-wmproxy-purge-proxycache" =
  nlist("pattern", WMS_LOCATION_LOG+'/glite-wms-wmproxy-purge-proxycache.ncm-cron.log',
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-wmproxy-purge-proxycache_keys" =
  nlist("pattern", WMS_LOCATION_LOG+'/glite-wms-wmproxy-purge-proxycache_keys.ncm-cron.log',
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

"/software/components/altlogrotate/entries/glite-wms-wmproxy-restart" =
  nlist("pattern", WMS_LOCATION_LOG+'/glite-wms-wmproxy-restart.ncm-cron.log',
        "compress", true,
        "missingok", true,
        "frequency", "monthly",
        "create", true,
        "ifempty", true,
        "rotate", 1);
