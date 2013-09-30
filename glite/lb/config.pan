unique template glite/lb/config;

include { 'glite/lb/variables' };

# Add site specific configuration, if any
include { return(LB_CONFIG_SITE) };


# Add c-ares library path
include { 'components/ldconf/config' };
"/software/components/ldconf/paths" = push("/opt/c-ares/lib");
"/software/components/ldconf/paths" = push("/opt/log4c/lib64");
"/software/components/ldconf/paths" = push("/opt/classads/lib64");

# Define some required environment variables and configure WMS services.
# Use full name for working directories in LB to avoid messing up WMS configuration.

include { 'components/wmslb/config' };
'/software/components/wmslb/dependencies/pre' = push('accounts','profile');
'/software/components/wmslb/confFile' = WMS_LOCATION_ETC + '/glite_wms.conf';
# Delete envScript property to prevent wmslb updating the profile script. This will be done
# by ncm-profile but env resource is still defined for ncm-wmslb to allow schema validation.
'/software/components/wmslb/envScript' = null;
 
# Define environment variables required by LB
include { 'common/lb/env' };

# Reset WMS configuration not to use LB proxy if LB is on the same machine
# if it has been defined previously.
'/software/components/wmslb/common/LBProxy' = if ( is_defined(SELF) ) {
                                                WMS_USE_LB_PROXY;
                                              } else {
                                                null;
                                              };

'/software/components/wmslb/services/logger/name' = 'LBLogger';
'/software/components/wmslb/services/logger/workDirs' = list(GLITE_LOCATION_VAR+'/logger');


# Add a few variables to grid-env.sh

include { 'components/profile/config' };
'/software/components/profile' = component_profile_add_env(
  GLITE_GRID_ENV_PROFILE, nlist(
    'GLITE_USER', GLITE_USER,
    'X509_CERT_DIR', SITE_DEF_CERTDIR,
    'X509_VOMS_DIR', SITE_DEF_VOMSDIR,
    'JAVA_HOME',JAVA_LOCATION,
    'GLITE_HOST_CERT','/home/glite/.certs/hostcert.pem',
    'GLITE_HOST_KEY','/home/glite/.certs/hostkey.pem',
    )
  );


# Add LB services to the list of gLite enabled services
# As ncm-wmslb is also used by WMS, avoid to add twice the same dependency (even if harmless)
include { 'components/glitestartup/config' };
'/software/components/glitestartup/configFile'='/etc/gLiteservices';
'/software/components/glitestartup/dependencies/pre' = glitestartup_add_dependency(list('accounts','dirperm','mysql','wmslb'));
'/software/components/glitestartup/restartEnv' = push(LB_PROFILE_SCRIPT);
"/software/components/glitestartup/scriptPaths" = list("/etc/init.d");
# FIXME : remove when glitestartup support defining a list of service to restart
'/software/components/glitestartup/restartServices' = true;
# This line is necessary because of PAN bug (see LCGQWG ticket #154)
'/software/components/glitestartup/services' = if ( exists(SELF) && is_defined(SELF) ) {
                                                 return(SELF);
                                               } else {
                                                 return(nlist());
                                               };
'/software/components/glitestartup/services' = {
  services = SELF;
  
  foreach (i;service;LB_SERVICES) {
    service = 'glite-lb-' + service;
    services = glitestartup_mod_service(service);
  };
  
  if ( is_defined(services) && (length(services) > 0) ) {
    return(services);
  } else {
    return(null);
  };
};


# Configure some directories

include { 'components/dirperm/config' };
'/software/components/dirperm/paths' = push(
  nlist(
    'path', LB_LOG_DIR,
    'owner', GLITE_USER+':'+GLITE_GROUP,
    'perm', '0775',
    'type', 'd'
  ),

);

# Configure Messaging
variable EMI_LB_MESSAGING_SERVER ?= 'tcp://egi-1.msg.cern.ch:6166';
include { 'glite/lb/messaging' };

# Configure MySQL database for LB
include { 'components/mysql/config' };
'/software/components/mysql/servers/' = {
  SELF[LB_MYSQL_SERVER]['adminuser'] = LB_MYSQL_ADMINUSER;
  SELF[LB_MYSQL_SERVER]['adminpwd'] = LB_MYSQL_ADMINPWD;
  SELF[LB_MYSQL_SERVER]['options']['max_allowed_packet'] = '17M';
  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[LB_KBSERVER_DB_NAME]['server'] = LB_MYSQL_SERVER;
  SELF[LB_KBSERVER_DB_NAME]['initScript']['file'] = LB_KBSERVER_DB_INIT_SCRIPT;
  # init script for LB doesn't have the if exists tests..
  SELF[LB_KBSERVER_DB_NAME]['initOnce'] = true;
  SELF[LB_KBSERVER_DB_NAME]['users'][LB_DB_USER] = nlist('password', LB_DB_PWD,
                                                'rights', list('ALL PRIVILEGES'),
                                               );
  SELF[LB_KBSERVER_DB_NAME]['tableOptions']['short_fields']['MAX_ROWS'] = '1000000000';
  SELF[LB_KBSERVER_DB_NAME]['tableOptions']['long_fields']['MAX_ROWS'] = '55000000';
  SELF[LB_KBSERVER_DB_NAME]['tableOptions']['events']['MAX_ROWS'] = '175000000';
  SELF[LB_KBSERVER_DB_NAME]['tableOptions']['states']['MAX_ROWS'] = '9500000';

  SELF;
};

#


# Create LB super users file
include { 'components/filecopy/config' };
'/software/components/filecopy/dependencies/post' = push('glitestartup');
'/software/components/filecopy/services' = {
  super_users = '';
  foreach (i;user;LB_TRUSTED_WMS) {
    super_users = super_users + user + "\n";
  };
  foreach (i;user;LB_SUPER_USERS) {
    super_users = super_users + user + "\n";
  };
  SELF[escape(LB_SUPER_USERS_FILE)] = nlist('config', super_users,
                                            'owner', 'root:root',
                                            'perms', '0644',
                                           );
  return(SELF);  
};

# Create etc/glite-lb/glite-lb-authz.conf file
'/software/components/filecopy/services' = {
  admin_users = '';
  read_users = '';
  status_users = '';
  general_events_users = '';
  register_users = '';
  purge_users = '';
  statistic_users = '';
  wms_events_users = '';
  ce_events_users = '';
  foreach (i;user;LB_ADMIN_ACCESS) {
   admin_users = admin_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_READ_ALL) {
   read_users = read_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_STATUS_FOR_MONITORING) {
   status_users = status_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_GENERAL_EVENTS) {
   general_events_users = general_events_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_REGISTER_JOBS) {
   register_users = register_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_PURGE) {
   purge_users = purge_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_GET_STATISTICS) {
   statistic_users = statistic_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_LOG_WMS_EVENTS) {
   wms_events_users = wms_events_users + "subject=\"" + user + "\"\n";
  };
  foreach (i;user;LB_LOG_CE_EVENTS) {
   ce_events_users = ce_events_users + "subject=\"" + user + "\"\n";
  };

  contents = 'resource "LB" {'+"\n";
  contents = if (length(admin_users) > 0) {
	contents +
                'action "ADMIN_ACCESS" {'+ "\n" +
                  'rule permit {'+ "\n"+
                               admin_users + 
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(read_users) > 0) {
	contents +
                'action "READ_ALL" {'+ "\n"+
                  'rule permit {'+ "\n"+
                                   read_users + 
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(status_users) > 0) {
	contents +
		'action "STATUS_FOR_MONITORING" {' + "\n" +
                  'rule permit {'+ "\n"+
				status_users +
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(purge_users) > 0) {
	contents +
		'action "PURGE" {' + "\n" +
                  'rule permit {'+ "\n"+
				purge_users +
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(statistic_users) > 0) {
	contents +
		'action "GET_STATISTICS" {' + "\n" +
                  'rule permit {'+ "\n"+
				statistic_users +
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(register_users) > 0) {
	contents +
		'action "REGISTER_JOBS" {' + "\n" +
                  'rule permit {'+ "\n"+
				register_users +
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(wms_events_users) > 0) {
	contents +
		'action "LOG_WMS_EVENTS" {' + "\n" +
                  'rule permit {'+ "\n"+
				wms_events_users +
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(ce_events_users) > 0) {
	contents +
		'action "LOG_CE_EVENTS" {' + "\n" +
                  'rule permit {'+ "\n"+
			ce_events_users +
                "}\n}\n";
	} else {
	contents;
	};
  contents = if (length(general_events_users) > 0) {
	contents +
		'action "LOG_GENERAL_EVENTS" {' + "\n" +
                  'rule permit {'+ "\n"+
				general_events_users +
                "}\n}\n";
	} else {
	contents;
	};
  contents = contents +
"}\n";


  SELF[escape(LB_AUTHZ_FILE)] = nlist('config', contents,
                         'owner', 'root:root',
                         'perms', '0644',
                        );
  return(SELF);
};


# Add LB cron jobs
include { 'common/lb/crons' };
