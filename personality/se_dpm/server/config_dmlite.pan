# dmlite configuration specific to head node
# Must be included after the configuration common to all nodes

unique template personality/se_dpm/server/config_dmlite;

variable DMLITE_MYSQL_NSPOOLSITE ?= 32;

# Set to true if dmlite memcache plugin should be enabled
variable DMLITE_MEMCACHE_ENABLED ?= false;
variable DMLITE_MEMCACHE_POOLSIZE ?= 500;

include { if (DMLITE_MEMCACHE_ENABLED) 'personality/se_dpm/rpms/memcached' };

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
    "NsPoolSize " + to_string(DMLITE_MYSQL_NSPOOLSITE) + "\n";
};
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED) {
    SELF[escape('/etc/dmlite.conf.d/mysql.conf')] = nlist(
        'config', contents,
        'owner', DPM_USER,
        'group', DPM_GROUP,
        'perms', '0640',
        'backup', false,
        'restart', '/sbin/service dpm-all-daemons restart',
    );
    SELF;
} else {
    SELF;
};

#
# /etc/dmlite.conf.d/zmemcache.conf
#
variable contents = {
  "LoadPlugin plugin_memcache /usr/" + library + "/dmlite/plugin_memcache.so\n" +
  "MemcachedServer localhost:11211\n" +
  "SymLinkLimit 5\n" +
  "MemcachedExpirationLimit 60\n" +
  "MemcachedProtocol binary\n" +
  "MemcachedPOSIX on\n" +
  "MemcachedFunctionCounter off\n" +
  "MemcachedBloomFilter off\n" +
  "MemcachedPoolSize " + to_string(DMLITE_MEMCACHE_POOLSIZE) + "\n";
};

'/software/components/filecopy/services' = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED && DMLITE_MEMCACHE_ENABLED) {
    SELF[escape('/etc/dmlite.conf.d/zmemcache.conf')] = nlist(
        'config', contents,
        'owner', 'root',
        'group', 'root',
        'perms', '0644',
        'backup', false,
        'restart', '/sbin/service dpm-all-daemons restart',
    );
    SELF;
} else {
    SELF;
};
