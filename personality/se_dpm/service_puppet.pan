unique template personality/se_dpm/service_puppet;

variable SEDPM_CONFIG_SITE ?= error("SEDPM_CONFIG_SITE should be defined");

include SEDPM_CONFIG_SITE;

variable SEDPM_MONITORING_ENABLED ?= false;
variable XROOT_ENABLED ?= true;
variable HTTPS_ENABLED ?= false;
variable DPM_MEMCACHED_ENABLED ?= false;

variable VOMS_XROOTD_EXTENSION_ENABLED ?= true;

variable XROOTD_FEDERATION_SITE_CONFIG ?= null;

variable SEDPM_IS_HEAD_NODE ?= FULL_HOSTNAME == DPM_HOSTS['dpm'][0];

variable SEDPM_PUPPET_USE_LEGACY ?= false;

#Removing pool accounts
include 'personality/se_dpm/puppet/no_pool_accounts';

#CMS Federation
include 'personality/se_dpm/puppet/federations';

include if (FULL_HOSTNAME == DPM_HOSTS['dpm'][0]) XROOTD_FEDERATION_SITE_CONFIG;

#Puppet configuration
include 'features/puppet/config';
include 'personality/se_dpm/puppet/puppetconf';

include 'personality/se_dpm/rpms/config';

'/software/packages' = {
    if (SEDPM_IS_HEAD_NODE){
        if (match(OS_VERSION_PARAMS['major'], '[es]l[56]')){
            pkg_repl('mysql-server');
        } else {
            pkg_repl('mariadb-server');
        };
    };
    SELF;
};

'/software/packages/{dmlite-plugins-memcache}' = {
    if (SEDPM_IS_HEAD_NODE && DPM_MEMCACHED_ENABLED) {
        dict();
    } else {
        null
    };
};

'/software/packages/{memcached}' = {
    if (SEDPM_IS_HEAD_NODE && DPM_MEMCACHED_ENABLED) {
        dict();
    } else {
        null;
    };
};

include if (FULL_HOSTNAME == DPM_HOSTS['dpm'][0]) 'personality/se_dpm/puppet/bdii';

include 'components/profile/config';

prefix '/software/components/profile/env';
'DPM_HOST' = DPM_HOSTS['dpm'][0];
'DPNS_HOST' = DPM_HOSTS['dpm'][0];
