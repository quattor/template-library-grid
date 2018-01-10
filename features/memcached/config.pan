unique template features/memcached/config;

variable MEMCACHED_PORT ?= 11211;
variable MEMCACHED_USER ?= 'memcached';
variable MEMCACHED_MAXCONN ?= 1024;
variable MEMCACHED_CACHESIZE ?= 64;
variable MEMCACHED_OPTIONS ?= '"-l 127.0.0.1 -U ' + to_string(MEMCACHED_PORT) + ' -t 4"';

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
  SELF['PORT'] = MEMCACHED_PORT;
  SELF['USER'] = MEMCACHED_USER;
  SELF['MAXCONN'] = MEMCACHED_MAXCONN;
  SELF['CACHESIZE'] = MEMCACHED_CACHESIZE;
  SELF['OPTIONS'] = MEMCACHED_OPTIONS;
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
