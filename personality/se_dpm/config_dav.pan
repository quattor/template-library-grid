unique template personality/se_dpm/config_dav;

#
# DPM_dav defaults
#
variable DPM_DAV_ENABLED ?= true;
variable HTTPD_CONF_DIR ?= "/etc/httpd";
variable DPM_DAV_ANON ?= "nobody";
variable DPM_DAV_NS_FLAGS ?= "Write";
variable DPM_DAV_DISK_FLAGS ?= "Write";
variable DPM_DAV_SECURE_REDIRECT ?= "On";
variable SSL_SESSION_CACHE ?= 1024000;
variable SSL_SESSION_CACHE_TIMEOUT ?= 7200;


#
# Consistency check
#
variable check = if ( !DMLITE_ENABLED ) error ("LCGDM HTTP / WebDAV requires DMLite");

#
# Enable httpd service
#
'/software/components/chkconfig/service/httpd' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    nlist(
        'on', '',
        'startstop', false,
    );
} else {
    SELF;
};

#
# Disable /etc/httpd/conf.d/ssl.conf
#
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape(HTTPD_CONF_DIR + '/conf.d/ssl.conf')] = nlist(
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
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape(HTTPD_CONF_DIR + '/conf.d/zgridsite.conf')] = nlist(
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
variable contents = {
    "#!/bin/bash\n" +
    'sed -i "s/User .*/User ' + DPM_USER + '/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/Group .*/Group ' + DPM_GROUP + '/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/#*ServerName .*/ServerName ' + FULL_HOSTNAME + '/g" ' +  HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/^LoadModule dav_module \(.*\)/#LoadModule dav_module \1/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/^LoadModule dav_fs_module \(.*\)/#LoadModule dav_fs_module \1/g" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n" +
    'sed -i "s/^[# ]*KeepAlive .*/KeepAlive On/" ' + HTTPD_CONF_DIR + "/conf/httpd.conf\n";
};
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape('/usr/local/quattor/sbin/dpm-dav_httpd.conf_patch.sh')] = nlist(
        'config', contents,
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

#
# Patch /etc/httpd/conf.d/zlcgdm-dav.conf
#
variable contents = {
    mydom = replace('\.', '\\\\\\\\.', DEFAULT_DOMAIN);
    this = "#!/bin/bash\n";
    this = this + 'sed -i "s:[# ]*SSLCertificateFile .*:    SSLCertificateFile ' + SITE_DEF_HOST_CERT + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*SSLCertificateKeyFile .*:    SSLCertificateKeyFile ' + SITE_DEF_HOST_KEY + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'grep -q "SSLCACertificatePath" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf &> /dev/null\n";
    this = this + "if [ $? -eq 0 ]; then\n";
    this = this + '    sed -i "s:[# ]*SSLCACertificatePath .*:    SSLCACertificatePath ' + SITE_DEF_CERTDIR + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + "else\n";
    this = this + '    sed -i "s:[# ]*SSLCACertificateFile .*:    SSLCACertificatePath ' + SITE_DEF_CERTDIR + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + "fi\n";
    this = this + 'sed -i "s:[# ]*SSLCARevocationPath .*:    SSLCARevocationPath ' + SITE_DEF_CERTDIR + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*SSLVerifyClient .*:    SSLVerifyClient require:g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*SSLVerifyDepth .*:    SSLVerifyDepth 10:g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*NSFlags\b.*:  NSFlags ' + DPM_DAV_NS_FLAGS + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*NSAnon .*:  NSAnon ' + DPM_DAV_ANON + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*NSSecureRedirect .*:  NSSecureRedirect ' + DPM_DAV_SECURE_REDIRECT + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*DiskAnon .*:  DiskAnon ' + DPM_DAV_ANON + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "s:[# ]*DiskFlags\b.*:  DiskFlags ' + DPM_DAV_DISK_FLAGS + ':g" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "/^<LocationMatch\s\"^\/(?!/ s#dpm[^|]*|#dpm/' + mydom + '/|#" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    this = this + 'sed -i "/^<LocationMatch\s\"^\/dpm/ s|/dpm.*|/dpm/' + mydom + '/.*\">|" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
    if (SSL_SESSION_CACHE > 0 && SSL_SESSION_CACHE_TIMEOUT > 0) {
        this = this + 'grep -q "SSLSessionCache" ' + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf &> /dev/null\n";
        this = this + "if [ $? -ne 0 -a -d /dev/shm ] ; then\n";
        this = this + "    echo '\n# SSL session cache\nSSLSessionCache shmcb:/dev/shm/ssl_gcache_data(" + to_string(SSL_SESSION_CACHE) + ")\nSSLSessionCacheTimeout " + to_string(SSL_SESSION_CACHE_TIMEOUT) + "' >> " + HTTPD_CONF_DIR + "/conf.d/zlcgdm-dav.conf\n";
        this = this + "fi\n";
    };
    this;
};

include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape('/usr/local/quattor/sbin/dpm-dav_zlcgdm-dav.conf_patch.sh')] = nlist(
        'config', contents,
        'owner', 'root',
        'group', 'root',
        'perms', '0755',
        'backup', false,
        'restart', '/usr/local/quattor/sbin/dpm-dav_zlcgdm-dav.conf_patch.sh',
    );
    SELF;
} else {
    SELF;
};

#
# Modify fetch-crl to reload Apache
#
variable contents = <<EOF;
#!/bin/bash
# Modify fetch-crl to reload Apache
if [ -f "/etc/cron.d/fetch-crl" ]; then
    grep -q "service httpd reload" "/etc/cron.d/fetch-crl"
    if [ $? -ne 0 ]; then
        if [ ! -f "/etc/fetch-crl.cron.backup" ]; then
            cp "/etc/cron.d/fetch-crl" "/etc/fetch-crl.cron.backup"
        fi
        # Parse old cronjob
        FETCH_CRL_CRONJOB=$(grep -x -P '^[^#\n].*' "/etc/cron.d/fetch-crl")
        FETCH_CRL_CMD=$(echo "${FETCH_CRL_CRONJOB}" | awk '{for (i = 7; i <= NF; i++) printf("%s ", $i);}')
        FETCH_CRL_TIME=$(echo "${FETCH_CRL_CRONJOB}" | awk '{printf("%s %s %s %s %s", $1, $2, $3, $4, $5);}')
        FETCH_CRL_USER=$(echo "${FETCH_CRL_CRONJOB}" | awk '{print $6;}')
        # Append to the command the reload of lcgdm-dav
        FETCH_CRL_CMD="{ ${FETCH_CRL_CMD}; } && /sbin/service httpd reload &> /dev/null"
        # Overwrite
        echo    "# fetch-crl cronjob regenerated by Quattor" > "/etc/cron.d/fetch-crl"
        echo    "# The old cronjob was copied as /etc/fetch-crl.cron.backup" >> "/etc/cron.d/fetch-crl"
        echo -e "${FETCH_CRL_TIME}\t${FETCH_CRL_USER}\t${FETCH_CRL_CMD}" >> "/etc/cron.d/fetch-crl"
    fi
fi
EOF
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DPM_DAV_ENABLED) && DPM_DAV_ENABLED) {
    SELF[escape('/usr/local/quattor/sbin/fetch-crl-cron_patch.sh')] = nlist(
        'config', contents,
        'owner', 'root',
        'group', 'root',
        'perms', '0755',
        'backup', false,
        'restart', '/usr/local/quattor/sbin/fetch-crl-cron_patch.sh',
    );
    SELF;
} else {
    SELF;
};
