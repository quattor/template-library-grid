unique template personality/se_dpm/puppet/puppetconf;

include 'components/puppet/config';

'/software/components/puppet/puppetconf/main/parser' = 'future';

include 'quattor/functions/package';

#Including the needed modules
variable DPM_PUPPET_RELEASE_MODULES ?= false;
variable DPM_PUPPET_FORGE_MODULES ?= !DPM_PUPPET_RELEASE_MODULES;

#Fixing some default values
variable GRIDFTP_REDIR_ENABLED ?= false;
variable HTTPS_ENABLED ?= false;
variable DPM_MEMCACHED_ENABLED ?= false;
variable GRIDFTP_REDIR_ENABLED ?= false;
variable DOME_ENABLED ?= false;
variable DOME_FLAVOUR ?= false;
variable DMLITE_TOKEN_PASSWORD ?= error('You should provide a token password of at least 32 characters');

variable DPM_LOG_LEVEL ?= 0;
variable DPM_DISK_LOG_LEVEL ?= DPM_LOG_LEVEL;
variable DPM_HEAD_LOG_LEVEL ?= DPM_LOG_LEVEL;

variable DPMMGR_UID ?= 970;
variable DPMMGR_GID ?= 970;

include if (DPM_PUPPET_FORGE_MODULES) 'personality/se_dpm/puppet/forge_modules';
include if (DPM_PUPPET_RELEASE_MODULES) 'personality/se_dpm/puppet/release_modules';

prefix '/software/components/puppet/hieradata';

'{classes}' = if (FULL_HOSTNAME == DPM_HOSTS['dpm'][0]) 'dpm::headnode' else 'dpm::disknode';

# base parameters
'{dpm::params::localdomain}' = SITE_DOMAIN;
'{dpm::params::headnode_fqdn}' = DPM_HOSTS['dpm'][0];
'{dpm::params::disk_nodes}' = DPM_HOSTS['disk'];
'{dpm::params::dpmmgr_uid}' = DPMMGR_UID;
'{dpm::params::dpmmgr_gid}' = DPMMGR_GID;
'{dmlite::disk::log_level}' = DPM_DISK_LOG_LEVEL;
'{dmlite::head::log_level}' = DPM_HEAD_LOG_LEVEL;
'{dpm::params::host_dn}' = if (is_defined(DPM_HOST_DN)) DPM_HOST_DN else null;

# supported vos
'{dpm::params::volist}' = VOS;

# passwords
'{dpm::params::token_password}' = DMLITE_TOKEN_PASSWORD;
'{dpm::params::xrootd_sharedkey}' = DPM_XROOTD_SHARED_KEY;
'{dpm::params::db_pass}' = DPM_DB_PARAMS['password'];
'{dpm::params::mysql_root_pass}' = DPM_DB_PARAMS['adminpwd'];

# xrootd conf
'{dpm::params::dpm_xrootd_fedredirs}' = XROOTD_FEDERATION_PARAMS;
'{dpm::params::xrd_report}' = if (is_defined(XROOTD_REPORTING_OPTIONS)) XROOTD_REPORTING_OPTIONS else null;
'{dpm::params::xrootd_monitor}' = if (is_defined(XROOTD_MONITORING_OPTIONS)) XROOTD_MONITORING_OPTIONS else null;
'{dpm::params::site_name}' = if (is_defined(XROOTD_SITE_NAME)) XROOTD_SITE_NAME else null;

# enable/disable options
'{dpm::params::webdav_enabled}' = if (HTTPS_ENABLED) 'yes' else 'no';
'{dpm::params::memcached_enabled}' = if (DPM_MEMCACHED_ENABLED) 'yes' else 'no';
'{dpm::params::gridftp_redirect}' =  if (GRIDFTP_REDIR_ENABLED) 'yes' else 'no';
'{dpm::params::configure_dome}' = if (DOME_ENABLED) 'yes' else 'no';
'{dpm::params::configure_domeadapter}' = if (DOME_FLAVOUR) 'yes' else 'no';

# disable in the puppet module some configuartions which are managed by quattor
'{dpm::params::configure_bdii}' = 'no';
'{dpm::params::configure_default_filesystem}' = 'no';
'{dpm::params::configure_default_pool}' = 'no';
'{dpm::params::configure_gridmap}' = 'no';
'{dpm::params::configure_repos}' = 'no';
'{dpm::params::configure_vos}' = 'no';
'{dpm::params::new_installation}' = 'no';
'{fetchcrl::manage_carepo}' = 'no';
'{fetchcrl::runboot}' = 'no';
'{fetchcrl::capkgs}' = if (is_defined(FETCHCRL_CAPKGS)) FETCHCRL_CAPKGS else null;

