unique template personality/se_dpm/puppet/mysql;

include 'features/mariadb/server';

# Define some default values for DB related properties
variable DPM_DB_NAME ?= 'dpm_db';
variable DPNS_DB_NAME ?= 'cns_db';
variable DPM_MYSQL_ADMINUSER_DEFAULT ?= 'root';
variable DPM_DB_USER ?= DPM_USER;
variable DPM_DB_INIT_SCRIPT ?= '/usr/share/lcgdm/create_dpm_tables_mysql.sql';
variable DPNS_DB_INIT_SCRIPT ?= '/usr/share/lcgdm/create_dpns_tables_mysql.sql';

variable DPM_DB_PARAMS = {
    if ( !is_defined(SELF['password']) ) {
        debug("DPM_DB_PARAMS['password'] undefined (DB connection password)");
    };
    if ( !is_defined(SELF['user']) ) {
        # DPM_DB_USER is the legacy variable
        if ( is_defined(DPM_DB_USER) ) {
            SELF['user'] = DPM_DB_USER;
        } else {
            SELF['user'] = DPM_USER;
        };
    };
    if ( !is_defined(SELF['adminuser']) ) {
        # DPM_MYSQL_ADMINUSER is the legacy variable
        if ( is_defined(DPM_MYSQL_ADMINUSER) ) {
            SELF['adminuser'] = DPM_MYSQL_ADMINUSER;
        } else {
            SELF['adminuser'] = DPM_MYSQL_ADMINUSER_DEFAULT;
        };
    };
    if ( !is_defined(SELF['adminpwd']) ) {
        # DPM_MYSQL_ADMINPWD is the legacy variable
        if ( is_defined(DPM_MYSQL_ADMINPWD) ) {
            SELF['adminpwd'] = DPM_MYSQL_ADMINPWD;
        } else {
            debug("DPM_DB_PARAMS['adminpwd'] undefined (DB '+DPM_DB_PARAMS['adminuser']+' password)");
        };
    };
    if ( !is_defined(SELF['server']) ) {
        if ( DPM_MYSQL_SERVER != FULL_HOSTNAME ) {
            SELF['server'] = DPM_MYSQL_SERVER;
        };
    };
    SELF;
};

include 'components/mysql/config';

# configure MySQL databases for DPM SE
'/software/components/mysql/servers' = {
    SELF[DPM_MYSQL_SERVER]['adminuser'] = DPM_DB_PARAMS['adminuser'];
    SELF[DPM_MYSQL_SERVER]['adminpwd'] = DPM_DB_PARAMS['adminpwd'];
    SELF;
};

'/software/components/mysql/databases' = {
    SELF[DPM_DB_NAME]['server'] = DPM_MYSQL_SERVER;
    SELF[DPM_DB_NAME]['createDb'] = false;
    SELF[DPM_DB_NAME]['initScript']['file'] = DPM_DB_INIT_SCRIPT;
    SELF[DPM_DB_NAME]['initOnce'] = true;
    SELF[DPM_DB_NAME]['users'][DPM_DB_PARAMS['user']] = dict(
        'password', DPM_DB_PARAMS['password'],
        'rights', list('ALL PRIVILEGES'),
    );

    SELF[DPNS_DB_NAME]['server'] = DPM_MYSQL_SERVER;
    SELF[DPNS_DB_NAME]['createDb'] = false;
    SELF[DPNS_DB_NAME]['initScript']['file'] = DPNS_DB_INIT_SCRIPT;
    SELF[DPNS_DB_NAME]['initOnce'] = true;
    SELF[DPNS_DB_NAME]['users'][DPM_DB_PARAMS['user']] = dict(
        'password', DPM_DB_PARAMS['password'],
        'rights', list('ALL PRIVILEGES'),
    );

    SELF;
};

include 'components/puppet/config';

'/software/components/puppet/dependencies/pre' = {
    push('mysql');
};

