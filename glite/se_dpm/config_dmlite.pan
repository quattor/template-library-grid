unique template glite/se_dpm/config_dmlite;

#
# DMLite defaults
#
variable DMLITE_ENABLED ?= true;
variable DMLITE_TOKEN_ID ?= 'ip';
variable DMLITE_TOKEN_LIFE ?= '1000';
variable DMLITE_TOKEN_PASSWORD ?= error('DMLITE_TOKEN_PASSWORD must be defined');

variable library = if (PKG_ARCH_DEFAULT == 'x86_64') {
    'lib64';
} else {
    'lib';
};

#
# /etc/dmlite.conf
#
variable contents = {
    "LoadPlugin plugin_config /usr/" + library + "/dmlite/plugin_config.so\n" +
    "Include /etc/dmlite.conf.d/*.conf\n";
};
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED) {
    SELF[escape('/etc/dmlite.conf')] = nlist(
        'config', contents,
        'owner', DPM_USER,
        'group', DPM_GROUP,
        'perms', '0640',
        'backup', false,
    );
    SELF;
} else {
    SELF;
};

#
# /etc/dmlite.conf.d
#
include { 'components/dirperm/config' };
'/software/components/dirperm/paths' = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED) {
    append(nlist(
        'path', '/etc/dmlite.conf.d',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd',
    ));
} else {
    SELF;
};

#
# /etc/dmlite.conf.d/mysql.conf
#
variable contents = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED && FULL_HOSTNAME == DPM_HOST) {
    "LoadPlugin plugin_mysql_dpm /usr/" + library + "/dmlite/plugin_mysql.so\n" +
    "MySqlHost " + DPM_MYSQL_SERVER + "\n" +
    "MySqlUsername " + DPM_DB_PARAMS['user'] + "\n" +
    "MySqlPassword " + DPM_DB_PARAMS['password'] + "\n" +
    "MySqlPort 0\n" +
    "NsDatabase " + DPNS_DB_NAME + "\n" +
    "DpmDatabase " + DPM_DB_NAME + "\n" +
    "MapFile /etc/lcgdm-mapfile\n" +
    "NsPoolSize 32\n";
} else {
    "# Disabled by Quattor\n";
};
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED) {
    SELF[escape('/etc/dmlite.conf.d/mysql.conf')] = nlist(
        'config', contents,
        'owner', DPM_USER,
        'group', DPM_GROUP,
        'perms', '0640',
        'backup', false,
    );
    SELF;
} else {
    SELF;
};

#
# /etc/dmlite.conf.d/adapter.conf
#
variable contents = {
    this = "LoadPlugin plugin_adapter_dpm /usr/" + library + "/dmlite/plugin_adapter.so\n";
    this = this + "LoadPlugin plugin_fs_io /usr/" + library + "/dmlite/plugin_adapter.so\n";
    if (FULL_HOSTNAME == DPM_HOST) {
        this = this + "LoadPlugin plugin_fs_pooldriver /usr/" + library + "/dmlite/plugin_adapter.so\n";
    };
    this = this + "DpmHost " + DPM_HOST + "\n";
    this = this + "TokenPassword " + DMLITE_TOKEN_PASSWORD + "\n";
    this = this + "TokenId " + DMLITE_TOKEN_ID + "\n";
    this = this + "TokenLife " + DMLITE_TOKEN_LIFE + "\n";
    this;
};
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = if (is_boolean(DMLITE_ENABLED) && DMLITE_ENABLED) {
    SELF[escape('/etc/dmlite.conf.d/adapter.conf')] = nlist(
        'config', contents,
        'owner', DPM_USER,
        'group', DPM_GROUP,
        'perms', '0640',
        'backup', false,
    );
    SELF;
} else {
    SELF;
};
