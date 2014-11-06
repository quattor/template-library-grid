unique template personality/se_dpm/service_puppet;

variable SEDPM_CONFIG_SITE ?= error("SEDPM_CONFIG_SITE should be defined");

include {SEDPM_CONFIG_SITE};

variable SEDPM_MONITORING_ENABLED?=false;
variable XROOT_ENABLED=true;
variable HTTPS_ENABLED?=false;
variable DPM_MEMCACHED_ENABLED?=false;

variable VOMS_XROOTD_EXTENSION_ENABLED = true;

variable XROOTD_FEDERATION_SITE_CONFIG?=null;

variable SEDPM_IS_HEAD_NODE ?= if( FULL_HOSTNAME == DPM_HOSTS['dpm'][0] ) {
                                 true;
                               } else {
                                 false;
                               };

#Removing pool accounts
include {'personality/se_dpm/puppet/no_pool_accounts'};

#CMS Federation
include {'personality/se_dpm/puppet/federations'};

include {if(FULL_HOSTNAME==DPM_HOSTS['dpm'][0]){XROOTD_FEDERATION_SITE_CONFIG}};

#Puppet configuration
include {'features/puppet/config'};
include {'personality/se_dpm/puppet/puppetconf'};

include 'personality/se_dpm/rpms/config';

'/software/packages/{mysql-server}' = if( SEDPM_IS_HEAD_NODE ){nlist()}else{null};

'/software/packages/{dmlite-plugins-memcache}' = if(SEDPM_IS_HEAD_NODE && DPM_MEMCACHED_ENABLED){nlist()}else{null};

'/software/packages/{memcached}' = if(SEDPM_IS_HEAD_NODE && DPM_MEMCACHED_ENABLED){nlist()}else{null};

include {if(FULL_HOSTNAME==DPM_HOSTS['dpm'][0]){'personality/se_dpm/puppet/bdii'}};

"/software/components/profile/env" = {
  SELF["DPM_HOST"] = DPM_HOSTS['dpm'][0];
  SELF["DPNS_HOST"] = DPM_HOSTS['dpm'][0];
  SELF;
};

