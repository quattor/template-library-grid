unique template personality/lb/variables;

#define *hardcoded middleware stuff
variable WMS_LOCATION_ETC = "/etc/glite-wms"; #this is *hardcoded* in middleware

variable LB_KBSERVER_DB_INIT_SCRIPT ?= '/usr/share/glite/glite-lb-dbsetup.sql';
variable LB_KBSERVER_DB_NAME ?= 'lbserver20';
# Default is not to use a password as LB doesn't allow to specify it in its configuration
variable LB_DB_PWD ?= '';
variable LB_DB_USER ?= 'lbserver';
# Use LB_MYSQL_ADMINUSER/PWD both on WMS and LB to ensure consistency if they are on the same node
variable LB_MYSQL_ADMINUSER ?= 'root';
variable LB_MYSQL_ADMINPWD ?= error('LB_MYSQL_ADMINPWD required but not specified');;
variable LB_MYSQL_SERVER ?= FULL_HOSTNAME;
variable LB_SERVICES = list('bkserverd','notif-interlogd');
variable LB_RTM_ENABLED ?= false;
variable GLITE_LB_EXPORT_PURGE_ARGS ?= '--cleared 2d --aborted 15d --cancelled 15d --done 15d --other 60d';
variable GLITE_LB_EXPORT_ENABLED ?= false;
variable LB_SERVICES = {
  if (GLITE_LB_TYPE == 'proxy' || GLITE_LB_TYPE == 'both' ) {
    push('proxy-interlogd');
  } else {
    SELF;
  };
};

variable  LB_SERVICES = {
  if (GLITE_LB_TYPE == 'server' || GLITE_LB_TYPE == 'both' ) {
    push('locallogger');
  } else {
    SELF;
  };
};

variable LB_SERVICES = {
  if ( LB_RTM_ENABLED ) {
    push('harvester');
  } else {
    SELF;
  };
};
variable LB_LOG_DIR ?= GLITE_LOCATION_LOG + '/wms';
variable LB_AUTHZ_FILE ?= GLITE_LOCATION_ETC + '/glite-lb/glite-lb-authz.conf';
# LB_SUPER_USERS and LB_TRUSTED_WMS are equivalent and just provided for convenience.
# Both may contain a list of DN that can act as LB super users, typically WMS.
variable LB_SUPER_USERS ?= list();
variable LB_TRUSTED_WMS ?= list();

variable LB_ADMIN_ACCESS ?= merge(LB_TRUSTED_WMS,LB_SUPER_USERS);
variable LB_STATUS_FOR_MONITORING ?= list();
variable LB_GET_STATISTICS ?= LB_TRUSTED_WMS;
variable LB_REGISTER_JOBS ?= list('.*');
variable LB_READ_ALL ?= LB_TRUSTED_WMS;
variable LB_PURGE ?= LB_TRUSTED_WMS;
variable LB_GRANT_OWNERSHIP ?= list();
variable LB_LOG_WMS_EVENTS ?= merge(LB_TRUSTED_WMS,list('.*'));
variable LB_LOG_CE_EVENTS ?= list('.*');
variable LB_LOG_GENERAL_EVENTS ?= list('.*');


# Configure WMS not to use LB proxy if LB is running on the same machine.
variable WMS_USE_LB_PROXY ?= false;

