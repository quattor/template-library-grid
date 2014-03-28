unique template personality/se_dpm/config_dmlite;

#
# DMLite defaults
#
# It doesn't make sense to have this variable false if executing this template...
variable DMLITE_ENABLED = true;
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
'/software/components/filecopy/services' = {
    SELF[escape('/etc/dmlite.conf')] = nlist(
        'config', contents,
        'owner', DPM_USER,
        'group', DPM_GROUP,
        'perms', '0640',
        'backup', false,
    );
    SELF;
};

#
# /etc/dmlite.conf.d
#
include { 'components/dirperm/config' };
'/software/components/dirperm/paths' = {
    append(nlist(
        'path', '/etc/dmlite.conf.d',
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd',
    ));
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
'/software/components/filecopy/services' = {
    SELF[escape('/etc/dmlite.conf.d/adapter.conf')] = nlist(
        'config', contents,
        'owner', DPM_USER,
        'group', DPM_GROUP,
        'perms', '0640',
        'backup', false,
    );
    SELF;
};
