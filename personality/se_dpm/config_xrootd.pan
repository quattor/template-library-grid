# The reference documentation, as of Jan. 2013, for configuring DPM/Xrootd is at
# https://svnweb.cern.ch/trac/lcgdm/wiki/Dpm/Xroot/ManualSetup

unique template personality/se_dpm/config_xrootd;

# Define basic Xrootd installation files and directories
include 'personality/xrootd/env';

# Xrootd sysconfig file
variable DPM_XROOTD_SYSCONFIG_FILE ?= XROOTD_INSTALL_ETC + '/sysconfig/xrootd';

# Use Alice token authorization mechanism
variable XROOTD_AUTH_USE_TOKEN ?= {
    if ( is_defined(XROOTD_TOKEN_AUTH_PARAMS) ) {
        true;
    } else {
        false;
    };
};
variable XROOTD_AUTH_LIBRARY_DPM ?= 'libXrdDPMRedirAcc.so.3';
variable XROOTD_AUTH_LIBRARY_TOKEN_AUTH ?= 'libXrdAliceTokenAcc.so.0.0.0';

# Shared key between Xrootd nodes used by DPM/Xrootd.
# Must be the same on all nodes participating to the Xrootd cluster.
# It is created by: dd bs=1 count=32 if=/dev/random | openssl base64
variable DPM_XROOTD_SHARED_KEY ?= {
    if ( XROOTD_AUTH_USE_TOKEN ) {
        undef;
    } else {
        error('DPM_XROOTD_SHARED_KEY undefined: no default');
    };
};
variable DPM_XROOTD_SHARED_KEY_FILE ?= XROOTD_CONFIG_DIR + '/dpmxrd-sharedkey.dat';

variable XROOTD_XROOTD_INSTANCES = {
    # At least one disk and one redir instances are needed
    disk_instance_found = false;
    redir_instance_found = false;
    if ( is_defined(SELF) ) {
        foreach (instance; params; SELF) {
            if ( params['type'] == 'disk' ) {
                disk_instance_found = true;
            } else  if ( params['type'] == 'redir' ) {
                redir_instance_found = true;
            };
        };
    };
    if ( !disk_instance_found ) {
        SELF['disk'] = dict(
            'type', 'disk',
            'configFile', XROOTD_CONFIG_DIR + '/xrootd-dpmdisk.cfg',
            'logFile', XROOTD_LOG_FILE
        );
    };
    if ( !redir_instance_found ) {
        SELF['redir'] = dict(
            'type', 'redir',
            'configFile', XROOTD_CONFIG_DIR + '/xrootd-dpmredir.cfg',
            'logFile', XROOTD_LOG_FILE,
        );
    };

    SELF;
};


#this variable sets the role of the node (redir, disk, both)
variable XROOTD_SERVER_ROLES = {
    if ( SEDPM_IS_HEAD_NODE ) {
        SELF[length(SELF)] = 'redir';
    };
    if ( index(FULL_HOSTNAME, DPM_HOSTS['disk']) >= 0 ) {
        SELF[length(SELF)] = 'disk';
    };
    if ( length(SELF) == 0 ) {
        error('Xrootd configuration inconsistency: node is neither a head node nor a disk server');
    };
    SELF;
};


# DPM/Xrootd expot path root
variable DPM_XROOTD_EXPORT_PATH_ROOT ?= {
    domain = replace('^[\w\-]+\.', '', DPM_HOSTS['dpm'][0]);
    '/dpm/' + domain + '/home';
};


# Ensure that required elements are configured if token-based authz is used
variable XROOTD_TOKEN_AUTH_PARAMS = {
    if ( XROOTD_AUTH_USE_TOKEN ) {
        # exportedVOs can be specified either as a list or dict. Convert to a
        # dict for easier further processing if this is a list.
        if ( !is_defined(SELF['exportedVOs']) ) {
            error("XROOTD_TOKEN_AUTH_PARAMS['exportedVOs'] is required when using Xrootd token-based authz");
        } else {
            if ( is_list(XROOTD_TOKEN_AUTH_PARAMS['exportedVOs']) ) {
                exported_vos = dict();
                foreach (i; vo; XROOTD_TOKEN_AUTH_PARAMS['exportedVOs']) {
                    exported_vos[vo] = dict();
                };
                SELF['exportedVOs'] = undef;
                SELF['exportedVOs'] = exported_vos;
            };
        };
        if ( !is_defined(SELF['principal']) ) {
            error("XROOTD_TOKEN_AUTH_PARAMS['principal'] is required when using Xrootd token-based authz");
        };
        if ( !is_defined(SELF['mappedFQANs']) ) {
            if ( length(SELF['exportedVOs']) == 1 ) {
                first(SELF['exportedVOs'], vo, params);
                SELF['mappedFQANs'] = list('/' + vo);
            } else {
                error("XROOTD_TOKEN_AUTH_PARAMS['mappedFQANs'] must be specified when multiple VOs are exported with token-based authz");
            };
        } else {
            if ( !is_list(SELF['mappedFQANs']) ) {
                error("XROOTD_TOKEN_AUTH_PARAMS['mappedFQANs'] must be a list");
            };
        };
        if ( !is_defined(SELF['authorizedPaths']) ) {
            if ( length(XROOTD_TOKEN_AUTH_PARAMS['exportedVOs']) == 1 ) {
                first(XROOTD_TOKEN_AUTH_PARAMS['exportedVOs'], vo, params);
                SELF['authorizedPaths'] = list(DPM_XROOTD_EXPORT_PATH_ROOT + '/' + vo);
            } else {
                error("XROOTD_TOKEN_AUTH_PARAMS['authorizedPaths'] must be specified when multiple VOs are exported with token-based authz");
            };
        };
        SELF['exportedPathRoot'] = DPM_XROOTD_EXPORT_PATH_ROOT;
    };

    SELF;
};


###############################
# DPM xrootd-related options  #
###############################

variable XROOTD_PARAMS = {
    if ( is_defined(DPM_XROOTD_PARAMS) ) {
        foreach (k; v; DPM_XROOT_PARAMS) {
            SELF[dpm][k] = v;
        };
    };

    if ( !is_defined(SELF['authzLibraries']) ) {
        SELF['authzLibraries'] = list(XROOTD_AUTH_LIBRARY_DPM);
        if ( XROOTD_AUTH_USE_TOKEN ) {
            SELF['authzLibraries'][length(SELF['authzLibraries'])] = XROOTD_AUTH_LIBRARY_TOKEN_AUTH;
        };
    };

    SELF['daemonUser'] = DPM_USER;
    SELF['daemonGroup'] = DPM_GROUP;

    SELF['dpm']['dpmHost'] = DPM_HOSTS['dpm'][0];
    SELF['dpm']['dpnsHost'] = DPM_HOSTS['dpns'][0];
    SELF['dpm']['defaultPrefix'] = DPM_XROOTD_EXPORT_PATH_ROOT;

    debug('XROOTD_PARAMS after DPM configuration: ' + to_string(SELF));
    SELF;
};


###############################################################################
# Sysconfig file for DPM/Xrootd
# Initial version of configuration files from templates provided in RPMs.
# Create a template from the provided template and when it is modified, update
# the actual file: this trick is used to prevent a modification loop between
# filecopy and dpmlfc.
###############################################################################

include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    SELF[escape(DPM_XROOTD_SYSCONFIG_FILE + '.templ-quattor')] = dict(
        'config', file_contents('personality/se_dpm/xrootd.dpm-templ'),
        'owner', 'root:root',
        'perms', '0644',
        'restart', 'cp ' + DPM_XROOTD_SYSCONFIG_FILE + '.templ-quattor ' + DPM_XROOTD_SYSCONFIG_FILE,
    );

    # DPM/Xrootd shared key
    if (is_defined(DPM_XROOTD_SHARED_KEY)) {
        SELF[escape(DPM_XROOTD_SHARED_KEY_FILE)] =  dict(
            'config', DPM_XROOTD_SHARED_KEY,
            'owner', 'dpmmgr:dpmmgr',
            'perms', '0640'
        );
    };

    # The Modified startup script functions
    # Note: this is to allow a nagios probe for the services. Should be rather
    # fixed in the release
    if (is_defined(XROOTD_MODIFIED_STARTUP_FUNCTIONS) && XROOTD_MODIFIED_STARTUP_FUNCTIONS) {
        SELF[escape('/etc/rc.d/init.d/xrootd-functions')] = dict(
            'config', file_contents('personality/se_dpm/templ/xrootd-functions.templ'),
            'owner', 'root:root',
            'perms', '0755',
        );
    };
    SELF;
};


# A mkgridmap entry is required when using token-based authz
variable MKGRIDMAP_DPMLFC_LOCAL_ENTRIES = {
    if (XROOTD_AUTH_USE_TOKEN) {
        SELF[XROOTD_TOKEN_AUTH_PARAMS['principal']] = XROOTD_TOKEN_AUTH_PARAMS['mappedFQANs'][0];
    };
    SELF
};


###########################
# LOG COMPRESSION LOGS    #
###########################

include 'components/cron/config';

variable XROOTD_LOG_GZIP_CMD ?= 'gzip /var/log/xrootd/*/*.log.[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]';
variable XROOTD_LOG_GZIP_TIME ?= "45 16 * * *";
"/software/components/cron/entries" = {
    push(dict(
        "name", "xrootd_log_gzip",
        "user", "root",
        "frequency", XROOTD_LOG_GZIP_TIME,
        'command', XROOTD_LOG_GZIP_CMD)
    );
};

