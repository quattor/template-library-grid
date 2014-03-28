# dmlite configuration specific to head node
# Must be included after the configuration common to all nodes

unique template personality/se_dpm/server/config_dmlite;

#
# /etc/dmlite.conf.d/mysql.conf
#
variable contents = {
    "LoadPlugin plugin_mysql_dpm /usr/" + library + "/dmlite/plugin_mysql.so\n" +
    "MySqlHost " + DPM_MYSQL_SERVER + "\n" +
    "MySqlUsername " + DPM_DB_PARAMS['user'] + "\n" +
    "MySqlPassword " + DPM_DB_PARAMS['password'] + "\n" +
    "MySqlPort 0\n" +
    "NsDatabase " + DPNS_DB_NAME + "\n" +
    "DpmDatabase " + DPM_DB_NAME + "\n" +
    "MapFile /etc/lcgdm-mapfile\n" +
    "NsPoolSize 32\n";
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

