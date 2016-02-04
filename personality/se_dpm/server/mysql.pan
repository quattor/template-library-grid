unique template personality/se_dpm/server/mysql;

# ----------------------------------------------------------------------------
# DB Configuration
# ----------------------------------------------------------------------------
include 'components/mysql/config';

variable DPM_DB_INIT_SCRIPT ?= '/usr/share/lcgdm/create_dpm_tables_mysql.sql';
variable DPNS_DB_INIT_SCRIPT ?= '/usr/share/lcgdm/create_dpns_tables_mysql.sql';

# configure MySQL databases for DPM SE
'/software/components/mysql/servers/' = {
  SELF[DPM_MYSQL_SERVER]['adminuser'] = DPM_DB_PARAMS['adminuser'];
  SELF[DPM_MYSQL_SERVER]['adminpwd'] = DPM_DB_PARAMS['adminpwd'];
  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[DPM_DB_NAME]['server'] = DPM_MYSQL_SERVER;
  SELF[DPM_DB_NAME]['createDb'] = false;
  SELF[DPM_DB_NAME]['initScript']['file'] = DPM_DB_INIT_SCRIPT;
  SELF[DPM_DB_NAME]['initOnce'] = true;
  SELF[DPM_DB_NAME]['users'][DPM_DB_PARAMS['user']] = nlist('password', DPM_DB_PARAMS['password'],
                                                           'rights', list('ALL PRIVILEGES'),
                                                          );

  SELF[DPNS_DB_NAME]['server'] = DPM_MYSQL_SERVER;
  SELF[DPNS_DB_NAME]['createDb'] = false;
  SELF[DPNS_DB_NAME]['initScript']['file'] = DPNS_DB_INIT_SCRIPT;
  SELF[DPNS_DB_NAME]['initOnce'] = true;
  SELF[DPNS_DB_NAME]['users'][DPM_DB_PARAMS['user']] = nlist('password', DPM_DB_PARAMS['password'],
                                                            'rights', list('ALL PRIVILEGES'),
                                                           );

  SELF;
};
