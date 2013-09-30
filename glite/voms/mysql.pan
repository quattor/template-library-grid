unique template glite/voms/mysql;

variable VOMS_MYSQL_ADMINUSER ?= 'root';
variable VOMS_MYSQL_ADMINPWD ?= 'myclearpass';
variable VOMS_DB_NAME ?= 'voms';
variable VOMS_DB_PWD ?= 'vomspwd';
variable VOMS_DB_USER ?= 'vomsserver';
variable VOMS_DB_INIT_SCRIPT ?= GLITE_LOCATION + '/etc/glite-voms-server.sql';

# Configure MySQL database for VOMS service
include { 'components/mysql/config' };
'/software/components/mysql/servers/' = {
  SELF[VOMS_DB_SERVER]['adminuser'] = VOMS_MYSQL_ADMINUSER;
  SELF[VOMS_DB_SERVER]['adminpwd'] = VOMS_MYSQL_ADMINPWD;
  SELF[VOMS_DB_SERVER]['options']['max_allowed_packet'] = '17M';
  SELF;
};


