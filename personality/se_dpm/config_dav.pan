unique template personality/se_dpm/config_dav;

#
# DPM_dav defaults
#
variable DPM_DAV_ENABLED ?= true;
variable HTTPD_CONF_DIR ?= "/etc/httpd";
variable DPM_DAV_MAXREQUESTSPERCHILD ?= 4000;


#
# Consistency check
#
variable check = if ( !DMLITE_ENABLED ) error ("LCGDM HTTP / WebDAV requires DMLite");

# Configure httpd to use the worker MPM
include 'components/metaconfig/config';
'/software/components/metaconfig/services/{/etc/sysconfig/httpd}' = {
    SELF['backup'] = '.quattor-saved';
    SELF['contents'] = dict('HTTPD', '/usr/sbin/httpd.worker');
    SELF['daemons'] = dict('httpd', 'restart');
    SELF['module'] = 'tiny';
    SELF;
};


#
# Disable /etc/httpd/conf.d/ssl.conf
#
include 'components/filecopy/config';
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape(HTTPD_CONF_DIR + '/conf.d/ssl.conf')] = dict(
        'config', "# Disabled by Quattor\n",
        'owner', 'root',
        'group', 'root',
        'perms', '0644',
        'backup', true,
    );
    SELF;
} else {
    SELF;
};

#
# Disable /etc/httpd/conf.d/zgridsite.conf
#
include 'components/filecopy/config';
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape(HTTPD_CONF_DIR + '/conf.d/zgridsite.conf')] = dict(
        'config', "# Disabled by Quattor\n",
        'owner', 'root',
        'group', 'root',
        'perms', '0644',
        'backup', true,
    );
    SELF;
} else {
    SELF;
};

#
# Patch /etc/httpd/conf/httpd.conf
#
variable PATCH_FILE_CONTENTS = {
    "#!/bin/bash\n" +
    'sed -i "s/User .*/User ' + DPM_USER + '/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/Group .*/Group ' + DPM_GROUP + '/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/#*ServerName .*/ServerName ' + FULL_HOSTNAME + '/g" ' +  HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/^LoadModule dav_module \(.*\)/#LoadModule dav_module \1/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/^LoadModule dav_fs_module \(.*\)/#LoadModule dav_fs_module \1/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/^[# ]*KeepAlive .*/KeepAlive On/" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/^MaxRequestsPerChild\s*0/MaxRequestsPerChild  ' + to_string(DPM_DAV_MAXREQUESTSPERCHILD) + '/" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n";

};
include 'components/filecopy/config';
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape('/usr/local/quattor/sbin/dpm-dav_httpd.conf_patch.sh')] = dict(
        'config', PATCH_FILE_CONTENTS,
        'owner', 'root',
        'group', 'root',
        'perms', '0755',
        'backup', false,
        'restart', '/usr/local/quattor/sbin/dpm-dav_httpd.conf_patch.sh',
    );
    SELF;
} else {
    SELF;
};

# Gracefully reload httpd every 6 hours so new CRLs are read
include 'components/cron/config';
'/software/components/cron/entries' = append(dict(
    'name', 'httpd-reload-CRL',
    'user', 'root',
    'frequency', '49 1,7,13,19 * * *',
    'command', "/sbin/service httpd graceful",
));

# Clean gridsite's session cache hourly
include 'components/cron/config';
'/software/components/cron/entries' = append(dict(
    'name', 'clean-gridsite-session-cache',
    'user', 'root',
    'frequency', '57 * * * *',
    'command', "/usr/bin/find /var/www/sessions -type f -cmin +1440 -delete",
));

