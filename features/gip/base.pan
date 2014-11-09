unique template features/gip/base;

# Define GIP directory layout
include { 'features/gip/env' };

# Define user/group used to run GIP scripts
variable GIP_USER ?= 'ldap';
variable GIP_GROUP ?= 'ldap';

# Create GIP user
include { 'users/' + GIP_USER };
include { 'users/' + GIP_GROUP };

# gip2
include { 'components/gip2/config' };

'/software/components/gip2/user' = GIP_USER;
'/software/components/gip2/group' = GIP_GROUP;
'/software/components/gip2/flavor' = GIP_FLAVOR;
'/software/components/gip2/basedir' = GIP_BASE_DIR;
'/software/components/gip2/etcDir' = GIP_SCRIPTS_CONF_DIR;
'/software/components/gip2/ldifDir' = GIP_LDIF_DIR;
'/software/components/gip2/pluginDir' = GIP_PLUGIN_DIR;
'/software/components/gip2/providerDir' = GIP_PROVIDER_DIR;
'/software/components/gip2/dependencies/pre' = push('accounts');

# Configure the list of GIP working directories.
'/software/components/gip2/workDirs' = list(
    GIP_TMP_DIR,
    GIP_CACHE_DIR,
);
