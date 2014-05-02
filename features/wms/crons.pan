
unique template feature/wms/crons;

variable WMS_CREATEPROXY_LOG ?= 'glite-wms-create-host-proxy.log';
variable WMS_PURGER_LOG ?= 'glite-wms-purger.log';

variable WMS_CRON_PURGESTORAGE_PARTIAL_INTERVAL ?= 6;
variable WMS_CRON_PURGESTORAGE_PARTIAL_TARGET ?= 40;
# Minimum number of days a file is kept before being eligible to purging. Default = 7 days
variable WMS_CRON_PURGESTORAGE_AGE_THRESHOLD ?= 1296000;

include { 'components/cron/config' };
include { 'components/altlogrotate/config' };

"/software/components/cron/entries" = 
  push(
    nlist(
      "name","glite-wms-check-daemons",
      "user","root",
      "frequency", "*/15 * * * *",
      "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . "+GLITE_GRID_ENV_PROFILE+";"+
       GLITE_LOCATION+"/libexec/glite-wms-check-daemons.sh"
     )
  );

# Add a cron job to create host proxy
"/software/components/cron/entries" =
  push(
    nlist(
      "name","glite-wms-create-host-proxy",
      "user",GLITE_USER,
      "frequency", "AUTO */6 * * *",
      "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . "+GLITE_GRID_ENV_PROFILE+";"+
      "/usr/sbin/glite-wms-create-proxy.sh "+WMS_X509_PROXY+" "+
      WMS_LOCATION_LOG+"/"+WMS_CREATEPROXY_LOG,
    )
  );

# glite-wms-purge storage is run only if needed Monday-Saturday and unconditonnally on Sunday
# This cron also takes care of renewing proxy used by WMS services.
"/software/components/cron/entries" = 
  push(
    nlist(
      "name","glite-wms-purgestorage-partial",
      "user",GLITE_USER,
      "frequency", "AUTO */" + to_string(WMS_CRON_PURGESTORAGE_PARTIAL_INTERVAL) + " * * 1-6",
      "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . "+GLITE_GRID_ENV_PROFILE+";"+
      GLITE_LOCATION+"/sbin/glite-wms-purgeStorage.sh -l "+
      WMS_LOCATION_LOG+"/"+WMS_PURGER_LOG + 
      " -p "+WMS_SANDBOX_DIR+" -t "+to_string(WMS_CRON_PURGESTORAGE_AGE_THRESHOLD)+
      " -a "+to_string(WMS_CRON_PURGESTORAGE_PARTIAL_TARGET),
    )
  );

"/software/components/cron/entries" = 
  push(
    nlist(
      "name","glite-wms-purgestorage-full",
      "user",GLITE_USER,
      "frequency", "AUTO 1 * * 0",
      "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . "+GLITE_GRID_ENV_PROFILE+";"+
      GLITE_LOCATION+"/sbin/glite-wms-purgeStorage.sh -l "+
      WMS_LOCATION_LOG+"/"+WMS_PURGER_LOG+ 
      " -p "+WMS_SANDBOX_DIR+" -t "+to_string(WMS_CRON_PURGESTORAGE_AGE_THRESHOLD),
    )
  );

"/software/components/cron/entries" = 
  push(
    nlist(
      "name","glite-wms-wmproxy-purge-proxycache",
      "user","root",
      "frequency", "AUTO */6 * * *",
      "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . "+GLITE_GRID_ENV_PROFILE+";"+
      GLITE_LOCATION+"/bin/glite-wms-wmproxy-purge-proxycache "+EMI_LOCATION_VAR+"/proxycache"
    )
  );

# Add a cron job to restart WMProxy everyday to ensure it is using the last CRL
"/software/components/cron/entries" =
  push(
    nlist(
      "name","glite-wms-wmproxy-restart",
      "user","root",
      "frequency", "AUTO 2 * * *",
      "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; . "+GLITE_GRID_ENV_PROFILE+";"+
      "/etc/init.d/glite-wms-wmproxy restart"
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

"/software/components/altlogrotate/entries/glite-wms-purgestoragei-full" = 
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

"/software/components/altlogrotate/entries/glite-wms-wmproxy-restart" =
  nlist("pattern", WMS_LOCATION_LOG+'/glite-wms-wmproxy-restart.ncm-cron.log',
        "compress", true,
        "missingok", true,
        "frequency", "monthly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

# Rotate lcmaps.log (created by WMS without any rotation entry, see https://savannah.cern.ch/bugs/?40389)
"/software/components/altlogrotate/entries/lcmaps" =
  nlist("pattern", GLITE_LOCATION_LOG+"/lcmaps.log",
        "compress", true,
        "missingok", true,
        "size", '100M',
        "create", true,
        "ifempty", true,
        "copytruncate", true,
        "rotate", 10,
        "createparams", nlist("mode", "0644",
                              "owner", GLITE_USER,
                              "group", GLITE_GROUP
                             ),
       );

