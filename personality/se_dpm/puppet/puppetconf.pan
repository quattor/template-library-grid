unique template personality/se_dpm/puppet/puppetconf;

include 'components/puppet/config';

'/software/components/puppet/puppetconf/main/parser' = 'future';

include 'quattor/functions/package';

#Including the needed modules
variable DPM_PUPPET_MODULE_VERSION ?= '1.8.9';
variable DPM_PUPPET_MODULE ?= 'sartiran-dpm';

'/software/components/puppet/modules' ?= dict();

'/software/components/puppet/modules' = {
    if(DPM_PUPPET_MODULE != 'NONE') {
        SELF[escape(DPM_PUPPET_MODULE)] = dict('version', DPM_PUPPET_MODULE_VERSION);
    };
    SELF;
};

variable DPMMGR_UID ?= 970;
variable DPMMGR_GID ?= 970;
variable DMLITE_TOKEN_PASSWORD ?= error('DMLITE_TOKEN_PASSWORD must be defined');

'/software/components/puppet/hieradata' = {
    self = dict();
    if(FULL_HOSTNAME == DPM_HOSTS['dpm'][0]) {
        self['classes'] = 'dpm::headnode';
    } else {
        self['classes'] = 'dpm::disknode';
    };
    self[escape('dpm::params::localdomain')] = SITE_DOMAIN;
    self[escape('dpm::params::headnode_fqdn')] = DPM_HOSTS['dpm'][0];

    self[escape('dpm::params::volist')] = VOS;

    if ( pkg_compare_version(DPM_PUPPET_MODULE_VERSION, '1.8.10') == PKG_VERSION_LESS ) {
        disk_list = '';
        foreach(i;disk;DPM_HOSTS['disk']) {
            if(disk_list == '') {
                disk_list = disk;
            } else {
                disk_list = disk_list + ' ' + disk;
            };
        };
    } else {
        disk_list = DPM_HOSTS['disk'];
    };

    self[escape('dpm::params::disk_nodes')] = disk_list;

    self[escape('dpm::params::dpmmgr_uid')] = DPMMGR_UID;
    self[escape('dpm::params::dpmmgr_gid')] = DPMMGR_GID;

    self[escape('dpm::params::token_password')] = DMLITE_TOKEN_PASSWORD;
    self[escape('dpm::params::xrootd_sharedkey')] = DPM_XROOTD_SHARED_KEY;
    self[escape('dpm::params::db_pass')] = DPM_DB_PARAMS['password'];

    self[escape('dpm::params::mysql_root_pass')] = DPM_DB_PARAMS['adminpwd'];
    self[escape('dpm::params::dpm_xrootd_fedredirs')] = XROOTD_FEDERATION_PARAMS;

    if(is_defined(XROOTD_REPORTING_OPTIONS)) {
        self[escape('dpm::params::xrd_report')] = XROOTD_REPORTING_OPTIONS;
    };

    if(is_defined(XROOTD_MONITORING_OPTIONS)) {
        self[escape('dpm::params::xrootd_monitor')] = XROOTD_MONITORING_OPTIONS;
    };

    if(is_defined(XROOTD_SITE_NAME)) {
        self[escape('dpm::params::site_name')] = XROOTD_SITE_NAME;
    };

    if(is_boolean(HTTPS_ENABLED)) {
        self[escape('dpm::params::webdav_enabled')] = HTTPS_ENABLED;
        if(is_boolean(DPM_MEMCACHED_ENABLED)) {
            self[escape('dpm::params::memcached_enabled')] = DPM_MEMCACHED_ENABLED;
        };
    };

    if(is_boolean(GRIDFTP_REDIR_ENABLED)) {
        self[escape('dpm::params::gridftp_redirect')] = GRIDFTP_REDIR_ENABLED;
    };

    if(is_boolean(SPACE_REPORTING_ENABLED)) {
        self[escape('dpm::params::enable_space_reporting')] = SPACE_REPORTING_ENABLED;
    };

    if(is_boolean(DOME_ENABLED)) {
        self[escape('dpm::params::enable_dome')] = DOME_ENABLED;
    };

    if(is_boolean(DOME_FLAVOUR)) {
        self[escape('dpm::params::enable_domeadapter')] = DOME_FLAVOUR;
    };

    self;
};
