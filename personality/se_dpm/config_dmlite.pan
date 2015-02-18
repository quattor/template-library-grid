unique template personality/se_dpm/config_dmlite;

# Define to 1.8.7 is you are not running 1.8 or later
variable DPM_VERSION ?= '1.8.8';

#
# DMLite defaults
#
# It doesn't make sense to have this variable false if executing this template...
variable DMLITE_ENABLED = true;
variable DMLITE_LOGLEVEL ?= '1';
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
include { 'components/filecopy/config' };
'/software/components/filecopy/services' = {
    this = "LoadPlugin plugin_config /usr/" + library + "/dmlite/plugin_config.so\n";
    if (DPM_VERSION > '1.8.8') {
        this = this + 'LogLevel ' + DMLITE_LOGLEVEL + "\n";
    };
    this = this + "Include /etc/dmlite.conf.d/*.conf\n";
    SELF[escape('/etc/dmlite.conf')] = nlist(
        'config', this,
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
# Note: plugin order is important. If a plugin is a superset of another one, it must be
#       loaded after the other plugin. When using, several configuration files, alphabetical
#       order of the configuration file must be used to ensure the appropriate load order.
#       This configuration file is normally loaded first.
#
variable contents = {
    this = '';
    if ( match(DPM_VERSION,'^1.8.7') ) {
      plugin_fs_io = 'plugin_fs_io';
    } else {
      plugin_fs_io = 'plugin_fs_rfio';
    };
    if ( SEDPM_IS_HEAD_NODE && (SEDPM_DB_TYPE == 'mysql') ) {
        # Needed by plugin_mysql_dpm loaded in mysql.conf
        this = this + "LoadPlugin plugin_fs_pooldriver /usr/" + library + "/dmlite/plugin_adapter.so\n";
    } else {
        # Required if plugin_mysql_dpm is not loaded
        this = this + "LoadPlugin plugin_adapter_dpm /usr/" + library + "/dmlite/plugin_adapter.so\n";
    };
    this = this + "LoadPlugin " + plugin_fs_io + " /usr/" + library + "/dmlite/plugin_adapter.so\n";
    this = this + "DpmHost " + DPM_HOSTS['dpns'][0] + "\n";
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
        'restart', '/sbin/service dpm-all-daemons restart',
    );
    SELF;
};
'/software/components/dpmlfc/dependencies/pre' = {
  if ( index('filecopy',SELF) == -1 ) {
    append('filecopy');
  };
  SELF;
}; 


# dmlite configuration specific to head node if needed
# Be sure to use the same condition as the one used to select which plugin to load in adapter.conf
include { if ( SEDPM_IS_HEAD_NODE && (SEDPM_DB_TYPE == 'mysql') ) 'personality/se_dpm/server/config_dmlite' };



