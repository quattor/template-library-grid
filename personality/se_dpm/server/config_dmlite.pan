# dmlite configuration specific to head node
# Must be included after the configuration common to all nodes

unique template personality/se_dpm/server/config_dmlite;

variable DMLITE_MYSQL_NSPOOLSIZE ?= 32;

@{
desc = configure and enable memcached usage in dmlite
values = boolean
required = no
default = true
}
variable DMLITE_MEMCACHE_ENABLED ?= true;
variable DMLITE_MEMCACHE_POOLSIZE ?= if ( (DPM_VERSION >= '1.9') || (DPM_VERSION == '1.8.9') || match(DPM_VERSION,'^1\.8\.1\d$') ) {
                                       250;
                                     } else {
                                       500;
                                     };
variable MEMCACHED_PORT ?= 11211;
variable MEMCACHED_MAXCONN ?= 8192;
variable MEMCACHED_CACHESIZE ?= 2048;
variable MEMCACHED_OPTIONS ?= '"-l 127.0.0.1 -U ' + to_string(MEMCACHED_PORT) + ' -t 4"';

variable DMLITE_SERVICE_RESTART_CMD ?= {
  services = list();
  if ( XROOT_ENABLED ) {
    services[length(services)] = 'xrootd';
  };
  if ( HTTPS_ENABLED ) {
    services[length(services)] = 'httpd';
  };
  if ( GSIFTP_ENABLED ) {
    services[length(services)] = 'dpm-gsiftp';
  };
  cmd = '';
  first = true;
  foreach (i;service;services) {
    if ( first ) {
      first = false;
    } else {
      cmd = cmd + '; ';
    };
    cmd = cmd + format('/sbin/service %s restart',service);
  };
  cmd;
};


include if ( DMLITE_MEMCACHE_ENABLED ) 'features/memcached/config';

#
# /etc/dmlite.conf.d/mysql.conf
#
variable contents = {
    "LoadPlugin plugin_mysql_dpm /usr/" + library + "/dmlite/plugin_mysql.so\n" +
    "MySqlHost " + DPM_MYSQL_SERVER + "\n" +
    "MySqlUsername " + DPM_DB_PARAMS['user'] + "\n" +
    "MySqlPassword " + DPM_DB_PARAMS['password'] + "\n" +
    "MySqlPort 0\n" +
    "NsDatabase " + DPNS_DB_NAME + "\n" +
    "DpmDatabase " + DPM_DB_NAME + "\n" +
    "MapFile /etc/lcgdm-mapfile\n" +
    "NsPoolSize " + to_string(DMLITE_MYSQL_NSPOOLSIZE) + "\n";
};
include 'components/filecopy/config';
'/software/components/filecopy/services' = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED) {
    SELF[escape('/etc/dmlite.conf.d/mysql.conf')] = nlist(
        'config', contents,
        'owner', DPM_USER,
        'group', DPM_GROUP,
        'perms', '0640',
        'backup', false,
        'restart', DMLITE_SERVICE_RESTART_CMD,
    );
    SELF;
} else {
    SELF;
};

#
# /etc/dmlite.conf.d/zmemcache.conf
#
variable contents = {
  if ( DMLITE_MEMCACHE_ENABLED ) {
    "LoadPlugin plugin_memcache /usr/" + library + "/dmlite/plugin_memcache.so\n" +
    "MemcachedServer localhost:" + to_string(MEMCACHED_PORT) + "\n" +
    "SymLinkLimit 5\n" +
    "MemcachedExpirationLimit 60\n" +
    "MemcachedProtocol binary\n" +
    "MemcachedPOSIX on\n" +
    "MemcachedFunctionCounter off\n" +
    "MemcachedBloomFilter off\n" +
    "MemcachedPoolSize " + to_string(DMLITE_MEMCACHE_POOLSIZE) + "\n";
  } else {
    '';
  };
};

'/software/components/filecopy/services' = if ( is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED ) {
    SELF[escape('/etc/dmlite.conf.d/zmemcache.conf')] = nlist(
        'config', contents,
        'owner', 'root',
        'group', 'root',
        'perms', '0644',
        'backup', false,
        'restart', DMLITE_SERVICE_RESTART_CMD,
    );
    SELF;
} else {
    SELF;
};
