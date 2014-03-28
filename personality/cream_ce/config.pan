# Actions specific to CREAM CE

template personality/cream_ce/config;

##TO_BE_FIXED:BEGIN these reconfigurations are probably not in the best place

"/software/components/glitestartup/configFile" = "/etc/gLiteservices";
"/software/components/glitestartup/restartEnv" = list("/etc/profile.d/env.sh","/etc/profile.d/grid-env.sh");
"/software/components/glitestartup/scriptPaths" = list("/etc/init.d");
'/software/components/glitestartup/active'      = false;

variable GLOBUS_GRIDFTP_CFGFILE ?= "/usr/etc/gridftp.conf";
'/software/components/profile' = component_profile_add_env(
  GLITE_GRID_ENV_PROFILE, nlist(
    'GLITE_USER', 'glite',
    'GLITE_HOST_CERT', '/home/glite/.certs/hostcert.pem',
    'GLITE_HOST_KEY', '/home/glite/.certs/hostkey.pem',
));



"/software/components/symlink/links" = {
  SELF[length(SELF)] =   nlist("name", "/usr/var/lib/trustmanager-tomcat",
                               "target", "/var/lib/trustmanager-tomcat",
                               "replace", nlist("all","yes"),
                              );
  SELF;
};


#TO_BE_FIXED: there are problems in the conf of the bdii which I cannot fix.. this just avoids that the component causes damages
"/software/components/lcgbdii/dir" = "/opt/glite";

############################################################################


# Default value defined in service.tpl
variable CREAM_SANDBOX_DIR ?= error('CREAM_SANDBOX_DIR required but undefined');

# Include some helper functions
include { 'feature/tomcat/functions' };

# Check that Tomcat has been configured and define a few variables based on Tomcat configuration
variable TOMCAT_USER ?= error('Tomcat must be configured before CREAM CE');
variable TOMCAT_CERT_DIR ?= TOMCAT_HOME + '/.certs';
variable TOMCAT_HOST_KEY ?= TOMCAT_CERT_DIR + '/hostkey.pem';
variable TOMCAT_HOST_CERT ?= TOMCAT_CERT_DIR + '/hostcert.pem';

# Redefine batch system name if defined as 'lcgpbs' (LCG CE specific variant of 'pbs')
variable CREAM_BATCH_SYS ?= if ( CE_BATCH_SYS == 'lcgpbs' ) {
                              'pbs';
                            } else {
                              CE_BATCH_SYS;
                            };
                            

# Specific CREAM CE variables

# Enable and configure CE Monitor
# Starting with CREAM 1.6, CE Monitor is disabled by default
variable CEMON_ENABLED ?= false;

# Location of log files
variable CREAM_LOG_DIR ?= GLITE_LOCATION_LOG;

# Location of working areas
variable CREAM_VAR_DIR ?= '/var/cream';

# Value to be published on GlueCEStateStatus (instead of production)
variable CREAM_CE_STATE ?= 'Production';

# directory where lsf.profile is installed. It's only used if lsf is used.
variable LSFPROFILE_DIR ?= '/etc';

# Script sourced by gLite services to define environment
variable GLITE_GRID_ENV_PROFILE ?= '/etc/profile.d/grid-env.sh';

# Hostname of the machine hosting the CREAM DB
variable CREAM_MYSQL_SERVER ?= FULL_HOSTNAME;

# CREAM DB user name and password (administrator and CREAM user)
# Build an XML-compliant representation of each password to be used
# in Tomcat configuration.
variable CREAM_MYSQL_ADMINUSER ?= 'root';
variable CREAM_MYSQL_ADMINPWD ?= error('CREAM_MYSQL_ADMINPWD required but not specified');
variable CREAM_DB_USER ?= 'creamdba';
variable CREAM_DB_PASSWORD ?= error('CREAM_DB_PASSWORD required but not specified');
variable CREAM_MYSQL_ADMINPWD_XML = tomcat5_to_xml_string(CREAM_MYSQL_ADMINPWD);
variable CREAM_DB_PASSWORD_XML = tomcat5_to_xml_string(CREAM_DB_PASSWORD);

# Databases used by the CREAM CE and their init scripts
variable CREAM_DB_NAME ?= 'creamdb';
variable DLG_DB_NAME ?= 'delegationcreamdb';
variable CREAM_DB_VERSION ?= '2.5';


variable CREAM_DB_INIT_SCRIPT ?= EMI_LOCATION + '/etc/glite-ce-cream/populate_creamdb_mysql.sql';
variable DLG_DB_INIT_SCRIPT ?= EMI_LOCATION + '/etc/glite-ce-cream/populate_delegationcreamdb.sql';

# Job purging
# Interval between 2 runs of the purger in minutes
variable CREAM_JOB_PURGE_RATE ?= 720;
# Job age (in days) before purging
variable CREAM_JOB_PURGE_POLICY_ABORTED ?= 10;
variable CREAM_JOB_PURGE_POLICY_CANCELED ?= 10;
variable CREAM_JOB_PURGE_POLICY_DONEOK ?= 15;
variable CREAM_JOB_PURGE_POLICY_DONEFAILED ?= 10;
variable CREAM_JOB_PURGE_POLICY_REGISTERED ?= 2;

# Delegation purging
variable CREAM_DELEGATION_PURGE_RATE ?= 720;

# Tomcat applicaton names
variable CREAM_CREAM_APP_NAME ?= 'ce-cream';

# log4j configuration files.
# Use a non standard name for Trustmanager to avoid conflict with the
# standard one (incomplete)
variable CREAM_TRUSTMANAGER_LOG4J_CONF_FILE = '/var/lib/trustmanager-tomcat/log4j-trustmanager.properties'; 
variable CREAM_CREAM_LOG4J_CONF_FILE = EMI_LOCATION + '/etc/glite-ce-cream/log4j.properties';               
 
# BasicDataSourceFactory class name
variable CREAM_DATA_SOURCE_FACTORY_CLASS ?= 'org.apache.commons.dbcp.BasicDataSourceFactory';

# Create BLParser environment config file (used by CREAM submission)
include { 'feature/blparser/blah-config' };

#-----------------------------------------------------------------------------
# Configuration for GLEXEC.
#-----------------------------------------------------------------------------
include { 'feature/glexec/cream_ce/config' };

#-----------------------------------------------------------------------------
# Configuration for CREAM monitoring
#-----------------------------------------------------------------------------
include { 'personality/cream_ce/monitor' };

#-----------------------------------------------------------------------------
# MySQL Configuration
#-----------------------------------------------------------------------------

include { 'components/mysql/config' };

# Configure MySQL databases for CREAM CE
'/software/components/mysql/servers/' = {
  SELF[CREAM_MYSQL_SERVER]['adminuser'] = CREAM_MYSQL_ADMINUSER;
  SELF[CREAM_MYSQL_SERVER]['adminpwd'] = CREAM_MYSQL_ADMINPWD;
  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[CREAM_DB_NAME]['server'] = CREAM_MYSQL_SERVER;
  SELF[CREAM_DB_NAME]['initScript']['file'] = CREAM_DB_INIT_SCRIPT;
  SELF[CREAM_DB_NAME]['initOnce'] = true;
  SELF[CREAM_DB_NAME]['users'][CREAM_DB_USER] = nlist('password', CREAM_DB_PASSWORD,
                                                'rights', list('ALL PRIVILEGES'),
                                               );

  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[DLG_DB_NAME]['server'] = CREAM_MYSQL_SERVER;
  SELF[DLG_DB_NAME]['initScript']['file'] = DLG_DB_INIT_SCRIPT;
  SELF[DLG_DB_NAME]['initOnce'] = true;
  SELF[DLG_DB_NAME]['users'][CREAM_DB_USER] = nlist('password', CREAM_DB_PASSWORD,
                                                'rights', list('ALL PRIVILEGES'),
                                               );

  SELF;
};

# Add a script for updating the database if necessary
include { 'personality/cream_ce/upgrade_db' };


# If home directories are not shared with a LCG CE, install LCG CE cron
# job to do account home directory cleanup (see https://savannah.cern.ch/bugs/?73283)
variable CREAM_HOMEDIR_CLEANUP ?= if ( is_defined(CE_HOSTS_LCG) &&
                                       (length(CE_HOSTS_LCG) > 0 ) &&
                                       CE_SHARED_HOMES ) {
                                    false;
                                  } else {
                                    true;
 
                                 };
#TO_BE_FIXED: just commented. To be checked later
#include { if ( CREAM_HOMEDIR_CLEANUP ) 'lcg/ce/cleanup-accounts' };


#------------------------------------------------------------------------------
# CREAM CE configuration file
#------------------------------------------------------------------------------

variable CREAM_CE_CONFIG = '/etc/glite-ce-cream/cream-config.xml';

variable CREAM_CE_CONFIG_CONTENTS=file_contents('personality/cream_ce/templates/cream-config.templ');

variable CEMON_URL={
	if( CEMON_ENABLED )
	{
		return("https://' + to_string(CEMON_HOST) + ':' + to_string(CEMON_PORT) + '/ce-monitor/services/CEMonitor");
	}else{
	return("NA");
	};
};

variable CREAM_CE_CONFIG_CONTENTS=replace('CEMON_URL_VALUE',CEMON_URL,CREAM_CE_CONFIG_CONTENTS);

variable CEMON_ENABLED_PART={
	    contents = '    <parameter name="CREAM_JOB_SENSOR_HOST" value="' + to_string(CEMON_HOST) + '" />' + "\n";
	    contents = contents + '    <parameter name="CREAM_JOB_SENSOR_PORT" value="9909" />' + "\n";
	    return(contents);
};

variable CREAM_CE_CONFIG_CONTENTS={
	if( CEMON_ENABLED )
        {
		replace('CEMON_ENABLED_PART',CEMON_ENABLED_PART,CREAM_CE_CONFIG_CONTENTS);
	}else{
		replace('CEMON_ENABLED_PART','',CREAM_CE_CONFIG_CONTENTS);
	};	
};
		
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_DB_VERSION_VALUE',CREAM_DB_VERSION,CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_VAR_DIR_VALUE',CREAM_VAR_DIR,CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_SANDBOX_DIR_VALUE',CREAM_SANDBOX_DIR,CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CATALINA_HOME_VALUE',CATALINA_HOME,CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_DELEGATION_PURGE_RATE_VALUE',to_string(CREAM_DELEGATION_PURGE_RATE),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('BLAH_JOBID_PREFIX_VALUE',to_string(BLAH_JOBID_PREFIX),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_JOB_PURGE_RATE_VALUE',to_string(CREAM_JOB_PURGE_RATE),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_JOB_PURGE_POLICY_ABORTED_VALUE',to_string(CREAM_JOB_PURGE_POLICY_ABORTED),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_JOB_PURGE_POLICY_CANCELED_VALUE',to_string(CREAM_JOB_PURGE_POLICY_CANCELED),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_JOB_PURGE_POLICY_DONEOK_VALUE',to_string(CREAM_JOB_PURGE_POLICY_DONEOK),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_JOB_PURGE_POLICY_DONEFAILED_VALUE',to_string(CREAM_JOB_PURGE_POLICY_DONEFAILED),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_JOB_PURGE_POLICY_REGISTERED_VALUE',to_string(CREAM_JOB_PURGE_POLICY_REGISTERED),CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_DB_USER_VALUE',CREAM_DB_USER,CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS=replace('CREAM_DB_PASSWORD_VALUE',CREAM_DB_PASSWORD,CREAM_CE_CONFIG_CONTENTS);



"/software/components/filecopy/services" =
  npush(escape(CREAM_CE_CONFIG),
        nlist("config",CREAM_CE_CONFIG_CONTENTS,
              "owner","root",
              "perms","0644",
              "restart", "/sbin/service "+TOMCAT_SERVICE+" restart",
        )
  );

#------------------------------------------------------------------------------
# CEMonitor configuration file
#------------------------------------------------------------------------------

include { if ( CEMON_ENABLED ) 'personality/cream_ce/cemonitor' };


#------------------------------------------------------------------------------
# Configure CREAM-related directory and file permissions
#------------------------------------------------------------------------------

'/software/components/dirperm/paths' = {
  # root
  SELF[length(SELF)] = nlist('path', '/etc/grid-security/admin-list',
                             'owner', 'root:root',
                             'perm', '0644',
                             'type', 'f',
                            );

    SELF[length(SELF)] = nlist('path', GLITE_LOCATION + '/sbin/JobDBAdminPurger.sh',
                               'owner', 'root:root',
                               'perm', '0700',
                               'type', 'f',
                              );

  # Tomcat
  SELF[length(SELF)] = nlist('path',  CREAM_VAR_DIR,
                             'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                             'perm', '0700',
                             'type', 'd',
                            );
  SELF[length(SELF)] = nlist('path', CREAM_SANDBOX_DIR,
                             'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                             'perm', '0755',
                             'type', 'd',
                            );
  SELF[length(SELF)] = nlist('path', '/var/proxies',
                             'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                             'perm', '0755',
                             'type', 'd',
                            );
  SELF[length(SELF)] = nlist('path', CREAM_LOG_DIR,
                             'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                             'perm', '0755',
                             'type', 'd',
                            );
    SELF[length(SELF)] = nlist('path', GLITE_LOCATION + '/bin/glite_cream_load_monitor',
                               'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                               'perm', '0700',
                               'type', 'f',
                              );

  SELF;
};


#------------------------------------------------------------------------------
# Configure the Tomcat web services, including glexec
#------------------------------------------------------------------------------

"/software/components/symlink/links" = {
  # CREAM web service dependencies
  SELF[length(SELF)] =   nlist("name", CATALINA_HOME+"/common/lib/mysql-connector-java.jar",
                               "target", "/usr/share/java/mysql-connector-java.jar",
                               "replace", nlist("all","yes"),
                               "exists", true,
                              );
  SELF[length(SELF)] =  nlist(
                               "name",    CATALINA_HOME+"/lib/glite-lb-client-java.jar",
                               "target",  "/usr/lib/java/glite-lb-client-java.jar",
                               "replace", nlist("all","yes"),
                               "exists",  true,
                             );
  SELF;
};


# Add tomcat user to glexec group
"/software/components/accounts/users" = {
  SELF;
};

variable TOMCAT_GLEXEC_WRAPPER_FILE = '/usr/share/'+TOMCAT_SERVICE+'/glexec-wrapper.sh';
variable TOMCAT_GLEXEC_WRAPPER_CONTENTS = {
  contents = "#!/bin/sh\n";
  contents = contents + "/usr/sbin/glexec $@\n";

  contents;
};

"/software/components/filecopy/services" =
  npush(escape(TOMCAT_GLEXEC_WRAPPER_FILE),
        nlist("config",TOMCAT_GLEXEC_WRAPPER_CONTENTS,
              "owner","root",
              "perms","0644",
       )
  );

variable CREAM_TRUSTMANAGER_CONFIG = 'trustmanager-tomcat.SSLTRUSTDIR = '+SITE_DEF_CERTDIR+"\n";
variable CREAM_TRUSTMANAGER_CONFIG = CREAM_TRUSTMANAGER_CONFIG + 'trustmanager-tomcat.SSLKEY = '+TOMCAT_HOST_KEY+"\n";
variable CREAM_TRUSTMANAGER_CONFIG = CREAM_TRUSTMANAGER_CONFIG + 'trustmanager-tomcat.SSLCERTFILE = '+TOMCAT_HOST_CERT+"\n";
variable CREAM_TRUSTMANAGER_CONFIG = CREAM_TRUSTMANAGER_CONFIG + 'trustmanager-tomcat.LOG4JCONF = '+
                                                                               CREAM_TRUSTMANAGER_LOG4J_CONF_FILE+"\n";
variable CREAM_TRUSTMANAGER_CONFIG = CREAM_TRUSTMANAGER_CONFIG + 'trustmanager-tomcat.PORT = '+to_string(CEMON_PORT)+"\n";
include {'components/filecopy/config'};
"/software/components/filecopy/services" = npush(

  escape("/var/lib/trustmanager-tomcat/config.properties"), nlist("config",    CREAM_TRUSTMANAGER_CONFIG,
                                           "restart","/var/lib/trustmanager-tomcat/configure.sh /; /sbin/service "+TOMCAT_SERVICE+" restart"),  
);

# Ensure Tomcat5 server.xml is matching the one needed for the CREAM CE
# as it may be overwritten by a RPM update. It is originally created by
# configure.sh that is run only if config.properties is modified. Rerun
# the same command if it not matching the expected one. Be sure to use
# the same command to execute it once whatever the number of modified
# files.



'/software/components/filecopy/services' = npush(
	escape('/etc/'+TOMCAT_SERVICE+'/server.xml'), nlist('source','/var/lib/trustmanager-tomcat/server.xml',
                                                 'owner', TOMCAT_USER+':root',
                                                 'perms','0644',
                                                 "restart","/var/lib/trustmanager-tomcat/configure.sh /usr; /sbin/service "+TOMCAT_SERVICE+" restart",
         )
    );

# Configure per-VO sandbox directories.
# Prior to CREAM 1.6, directory is created by the CE and thus tomcat
# user must belong to the VO groups to set the appropriate group
# ownership.
# With CREAM 1.6 and later, the top level directory must be created
# as part of the configuration.

"/software/components/accounts/users" = {
  SELF;
};

"/software/components/dirperm/paths" = {
    foreach(k;vo;VOS) {
      SELF[length(SELF)] = nlist('path',CREAM_SANDBOX_DIR+'/'+vo,
                                 'owner',TOMCAT_USER+':'+VO_INFO[vo]['group'],
                                 'perm','0770',
                                 'type','d'
                                );
    };
    #create secondary groups sandbox dir, if those groups are used as primary  groups
    if(is_defined(VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP) && VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP) {
    	foreach(k;vo;VOS) {
    		if(is_defined(VO_INFO[vo]['accounts']['groups'])) {
	    		foreach(group;gid;VO_INFO[vo]['accounts']['groups']) {
	      			SELF[length(SELF)] = nlist('path',CREAM_SANDBOX_DIR+'/'+group,
	                                 'owner',TOMCAT_USER+':'+group,
	                                 'perm','0770',
	                                 'type','d'
	                                );
				};
			};
    	};	
    };
  SELF;
};

# Do a copy of machine cert/key for Tomcat usage
'/software/components/filecopy/services' = {
  SELF[escape(TOMCAT_HOST_KEY)] = nlist('source', SITE_DEF_HOST_KEY,
                                        'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                                        'perms', '0400',
                                        'restart', '/sbin/service '+TOMCAT_SERVICE+' restart',
                                       );
  SELF[escape(TOMCAT_HOST_CERT)] = nlist('source', SITE_DEF_HOST_CERT,
                                         'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                                         'perms', '0400',
                                         'restart', '/sbin/service '+TOMCAT_SERVICE+' restart',
                                        );
  SELF;
};


# Define log4j configuration for CREAM CE (default one is invalid).
# This includes glite-security-trustmanager
# Define log4j main logger configuration.
# Ignored if log4j is not used.
include { 'components/filecopy/config' };


variable CREAM_TRUSTMANAGER_LOG4J_CONF = {
  root_logger = create('feature/tomcat/root-logger');
  app_logger = create('personality/cream_ce/trustmanager-logger');
  app_logger['conf'] = replace('%%LOGFILE%%',
                               CREAM_LOG_DIR+'/trustmanager-tomcat.log',
                               app_logger['conf']
                              );
  config = root_logger['conf'] + "\n" + app_logger['conf'];
  config;
};
'/software/components/filecopy/services' = {
  SELF[escape(CREAM_TRUSTMANAGER_LOG4J_CONF_FILE)] = nlist('config', CREAM_TRUSTMANAGER_LOG4J_CONF,
                                                             'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                                                             'restart', '/sbin/service '+TOMCAT_SERVICE+' restart',
                                                            );
  SELF;
};

variable CREAM_CREAM_LOG4J_CONF = {
  root_logger = create('feature/tomcat/root-logger');
  app_logger = create('personality/cream_ce/ce-cream-logger');
  app_logger['conf'] = replace('%%LOGFILE%%',
                               CREAM_LOG_DIR+'/glite-ce-cream.log',
                               app_logger['conf']
                              );
  config = root_logger['conf'] + "\n" + app_logger['conf'];
  config;
};
'/software/components/filecopy/services' = {
  SELF[escape(CREAM_CREAM_LOG4J_CONF_FILE)] = nlist('config', CREAM_CREAM_LOG4J_CONF,
                                                      'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                                                      'restart', '/sbin/service '+TOMCAT_SERVICE+' restart',
                                                     );
  SELF;
};


#------------------------------------------------------------------------------
# Configure sudo 
#------------------------------------------------------------------------------

variable SUDOERS_INCLUDE = {
    "personality/cream_ce/sudoers";
};

include { SUDOERS_INCLUDE };


#------------------------------------------------------------------------------
# Add a cron job to restart Tomcat everyday to ensure it is using the last CRL.
#------------------------------------------------------------------------------
variable CREAM_DAILY_RESTART ?= false;
"/software/components/cron/entries" = {
    if (is_boolean(CREAM_DAILY_RESTART) && CREAM_DAILY_RESTART) {
        push(nlist(
            "name","tomcat-restart",
            "user","root",
            "frequency", "AUTO 2 * * *",
            "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; " + '/sbin/service '+TOMCAT_SERVICE+' restart',
        ));
    } else {
        SELF;
    };
};

"/software/components/altlogrotate/entries" = {
    if (is_boolean(CREAM_DAILY_RESTART) && CREAM_DAILY_RESTART) {
        SELF['tomcat-restart'] = nlist(
            "pattern", "/var/log/tomcat-restart.ncm-cron.log",
            "compress", true,
            "missingok", true,
            "frequency", "monthly",
            "create", true,
            "ifempty", true,
            "rotate", 1,
        );
    };
    SELF;
};


#------------------------------------------------------------------------------
# glexec fails if permissions are wrong, always run dirperm after spma
#------------------------------------------------------------------------------
# Chicken / Egg problem w/ SPMA if dirperm is a dependency
#include { 'components/spma/config' };
#'/software/components/spma/dependencies/post' = append('dirperm');

variable TORQUE_COMMAND_LINKS ?= false;
include { 'components/symlink/config' };
"/software/components/symlink/links" = if (TORQUE_COMMAND_LINKS) {
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qstat",
        "target", "/usr/bin/qstat-torque",
        "replace", nlist("link","yes"),				
        "exists", true,		
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qsub",
        "target", "/usr/bin/qsub-torque",
        "replace", nlist("link","yes"),
        "exists", true,					
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qhold",
        "target", "/usr/bin/qhold-torque",
        "replace", nlist("link","yes"),
        "exists", true,		
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qrls",
        "target", "/usr/bin/qrls-torque",
        "replace", nlist("link","yes"),
        "exists", true,						
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qalter",
        "target", "/usr/bin/qalter-torque",
        "replace", nlist("link","yes"),
        "exists", true,						
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qselect",
        "target", "/usr/bin/qselect-torque",
        "replace", nlist("link","yes"),
        "exists", true,						
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qdel",
        "target", "/usr/bin/qdel-torque",
        "replace", nlist("link","yes"),
        "exists", true,						
    );
    SELF;
} else {
    SELF;
};
