unique template personality/lb/config;

include { 'personality/lb/variables' };

# Add site specific configuration, if any
include { return(LB_CONFIG_SITE) };

# Define some required environment variables and configure services.
include { 'components/wmslb/config' };
'/software/components/wmslb/dependencies/pre' = push('accounts','profile');
'/software/components/wmslb/confFile' = WMS_LOCATION_ETC + '/glite_wms.conf';
# Delete envScript property to prevent wmslb updating the profile script. This will be done
# by ncm-profile but env resource is still defined for ncm-wmslb to allow schema validation.
'/software/components/wmslb/envScript' = null;
 
# Define environment variables required by LB
include { 'features/lb/env' };

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
    'GLITE_LB_EXPORT_PURGE_ARGS',GLITE_LB_EXPORT_PURGE_ARGS,
    'GLITE_LB_EXPORT_ENABLED',GLITE_LB_EXPORT_ENABLED,
    )
  );


# Add LB services to the list of gLite enabled services
include { 'features/lb/glitestartup' };
'/software/components/glitestartup/dependencies/pre' = glitestartup_add_dependency(list('wmslb'));
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

'/software/components/dirperm/paths' = push(
  nlist(
    'path', EMI_LOCATION_VAR + '/run/glite',
    'owner', GLITE_USER+':'+GLITE_GROUP,
    'perm', '0755',
    'type', 'd'
  ),
);

# Configure Messaging
variable EMI_LB_MESSAGING_SERVER ?= 'tcp://egi-1.msg.cern.ch:6166';
include { 'personality/lb/messaging' };

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


# Create etc/glite-lb/glite-lb-authz.conf file
'/software/components/filecopy/services' = {
  contents = 'resource "LB" {' + "\n";
  contents = contents + '  action "ADMIN_ACCESS" {'+ "\n";
  foreach (i; user; LB_ADMIN_ACCESS) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "STATUS_FOR_MONITORING" {'+ "\n";
  foreach (i; user; LB_STATUS_FOR_MONITORING) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "GET_STATISTICS" {'+ "\n";
  foreach (i; user; LB_GET_STATISTICS) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "REGISTER_JOBS" {'+ "\n";
  foreach (i; user; LB_REGISTER_JOBS) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "READ_ALL" {'+ "\n";
  foreach (i; user; LB_READ_ALL) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "PURGE" {'+ "\n";
  foreach (i; user; LB_PURGE) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "GRANT_OWNERSHIP" {'+ "\n";
  foreach (i; user; LB_GRANT_OWNERSHIP) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "LOG_WMS_EVENTS" {'+ "\n";
  foreach (i; user; LB_LOG_WMS_EVENTS) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "LOG_CE_EVENTS" {'+ "\n";
  foreach (i; user; LB_LOG_CE_EVENTS) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '  action "LOG_GENERAL_EVENTS" {'+ "\n";
  foreach (i; user; LB_LOG_GENERAL_EVENTS) {
    contents = contents + '    rule permit {' + "\n"
                        + '      subject = "' + user + '"' + "\n"
                        + '    }' + "\n";
  };
  contents = contents + '  }' + "\n";
  contents = contents + '}' + "\n";


  SELF[escape(LB_AUTHZ_FILE)] = nlist('config', contents,
                         'owner', 'root:root',
                         'perms', '0644',
                        );
  return(SELF);
};


# Add LB cron jobs
include { 'features/lb/crons' };
