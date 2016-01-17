unique template features/memcached/config;

include 'components/metaconfig/config';

# Add RPMs
include 'features/memcached/rpms';

# Configure memcached daemon
include 'components/metaconfig/config';
include 'features/memcached/schema';
prefix '/software/components/metaconfig/services/{/etc/sysconfig/memcached}';
'daemons' = nlist('memcached', 'restart');
'backup' = '.old';
'module' = 'tiny';
'contents' = {
  SELF['PORT'] = 11211;
  SELF['USER'] = "memcached";
  SELF['MAXCONN'] = 1024;
  SELF['CACHESIZE'] = 64;
  SELF['OPTIONS'] = '"-l 127.0.0.1 -U 11211 -t 4"';
  SELF;
};
bind '/software/components/metaconfig/services/{/etc/sysconfig/memcached}/contents' = memcached_sysconfig_keys;

# Start memcached daemon
include 'components/chkconfig/config';
prefix '/software/components/chkconfig/service';
'memcached/on' = "";
'memcached/startstop' = true;

# Ensure that memcached user is preserved by ncm-accounts
include 'components/accounts/config';
'/software/components/accounts/kept_users/memcached' = '';
