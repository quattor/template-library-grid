unique template personality/apel/config;

# Hostname of the machine hosting the APEL DB
variable APEL_HOST ?= FULL_HOSTNAME;

# APEL DB admin username and password
variable APEL_MYSQL_ADMINUSER ?= 'root';
variable APEL_MYSQL_ADMINPWD ?= error('APEL_MYSQL_ADMINPWD required but not specified');
variable APEL_DB_USER ?= 'apel';
variable APEL_DB_PWD ?= error('APEL_DB_PASSWORD required but not specified');

# Database used by APEL and its init script
variable APEL_DB_NAME ?= 'apelclient';
variable APEL_DB_INIT_SCRIPT ?= '/usr/share/apel/client.sql';

#-----------------------------------------------------------------------------
# MySQL Database Configuration
#-----------------------------------------------------------------------------

include { 'components/mysql/config' };

# Authorized publisher hosts
variable AUTHORIZED_HOSTS ?= {
  publisher_list = list();

  publisher_list[length(publisher_list)] = 'localhost';
  publisher_list[length(publisher_list)] = 'localhost.localdomain';
  publisher_list[length(publisher_list)] = APEL_HOST;
  foreach(i;ce;CE_HOSTS) {
    publisher_list[length(publisher_list)] = ce;
  };

  publisher_list;
};

# Configure MySQL database for MONBOX
'/software/components/mysql/servers/' = {
  SELF[APEL_HOST]['adminuser'] = APEL_MYSQL_ADMINUSER;
  SELF[APEL_HOST]['adminpwd'] = APEL_MYSQL_ADMINPWD;
  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[APEL_DB_NAME]['server'] = APEL_HOST;
  SELF[APEL_DB_NAME]['initScript']['file'] = APEL_DB_INIT_SCRIPT;
  SELF[APEL_DB_NAME]['initOnce'] = true;
  foreach (i;host;AUTHORIZED_HOSTS) {
    SELF[APEL_DB_NAME]['users'][escape(APEL_DB_USER+'@'+host)] = nlist('password', APEL_DB_PWD,
                                                            'rights', list('ALL PRIVILEGES'),
                                                      );
  };

  SELF;
};

