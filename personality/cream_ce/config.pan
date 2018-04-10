# Actions specific to CREAM CE

template personality/cream_ce/config;

variable GLOBUS_GRIDFTP_CFGFILE ?= "/usr/etc/gridftp.conf";
'/software/components/profile' = component_profile_add_env(
    GLITE_GRID_ENV_PROFILE, dict(
        'GLITE_USER', 'glite',
        'GLITE_HOST_CERT', '/home/glite/.certs/hostcert.pem',
        'GLITE_HOST_KEY', '/home/glite/.certs/hostkey.pem',
    ),
);


"/software/components/symlink/links" = {
    append(dict(
        "name", "/usr/share/tomcat6/lib/canl.jar",
        "target", "/usr/share/java/canl.jar",
        "replace", dict("all", "yes"),
    ));
    append(dict(
        "name", "/usr/share/tomcat6/lib/canl-java-tomcat.jar",
        "target", "/usr/share/java/canl-java-tomcat.jar",
        "replace", dict("all", "yes"),
    ));
    append(dict(
        "name", "/usr/share/tomcat6/lib/commons-io.jar",
        "target", "/usr/share/java/commons-io.jar",
        "replace", dict("all", "yes"),
    ));
    SELF;
};


# Required by ncm-lcgbdii after change of GLITE_LOCATION in EMI
# FIXME: to be reviewed
include 'components/lcgbdii/config';
"/software/components/lcgbdii/dir" = "/opt/glite";

############################################################################


# Default value defined in service.tpl
variable CREAM_SANDBOX_DIR ?= error('CREAM_SANDBOX_DIR required but undefined');

# Include some helper functions
include 'features/tomcat/functions';

# Check that Tomcat has been configured and define a few variables based on Tomcat configuration
variable TOMCAT_USER ?= error('Tomcat must be configured before CREAM CE');
variable TOMCAT_CERT_DIR ?= TOMCAT_HOME + '/.certs';
variable TOMCAT_HOST_KEY ?= TOMCAT_CERT_DIR + '/hostkey.pem';
variable TOMCAT_HOST_CERT ?= TOMCAT_CERT_DIR + '/hostcert.pem';

# Redefine batch system name if defined as 'lcgpbs' (LCG CE specific variant of 'pbs')
variable CREAM_BATCH_SYS ?= {
    if ( CE_BATCH_SYS == 'lcgpbs' ) {
        'pbs';
    } else {
        CE_BATCH_SYS;
    };
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
variable CREAM_CREAM_LOG4J_CONF_FILE = EMI_LOCATION + '/etc/glite-ce-cream/log4j.properties';

# BasicDataSourceFactory class name
variable CREAM_DATA_SOURCE_FACTORY_CLASS ?= 'org.apache.commons.dbcp.BasicDataSourceFactory';

# Create BLParser environment config file (used by CREAM submission)
include 'features/blparser/blah-config';

#-----
# Add a script to purge running job that are keeped on cream_ce
#----
variable CREAM_PURGE_RUNNING_ENABLE ?= false;

include if (CREAM_PURGE_RUNNING_ENABLE) 'personality/cream_ce/purge-running';

#-----------------------------------------------------------------------------
# Configure Central Ban
#-----------------------------------------------------------------------------
variable CREAM_CENTRAL_BAN_ENABLE ?= false;
include if (CREAM_CENTRAL_BAN_ENABLE) 'personality/cream_ce/central-ban';

#-----------------------------------------------------------------------------
# Configuration for GLEXEC.
#-----------------------------------------------------------------------------
include 'features/glexec/cream_ce/config';

#-----------------------------------------------------------------------------
# Configuration for CREAM monitoring
#-----------------------------------------------------------------------------
include 'personality/cream_ce/monitor';

#-----------------------------------------------------------------------------
# MySQL Configuration
#-----------------------------------------------------------------------------

include 'components/mysql/config';

# Configure MySQL databases for CREAM CE
'/software/components/mysql/servers' = {
    SELF[CREAM_MYSQL_SERVER]['adminuser'] = CREAM_MYSQL_ADMINUSER;
    SELF[CREAM_MYSQL_SERVER]['adminpwd'] = CREAM_MYSQL_ADMINPWD;
    SELF;
};

'/software/components/mysql/databases' = {
    SELF[CREAM_DB_NAME]['server'] = CREAM_MYSQL_SERVER;
    SELF[CREAM_DB_NAME]['initScript']['file'] = CREAM_DB_INIT_SCRIPT;
    SELF[CREAM_DB_NAME]['initOnce'] = true;
    SELF[CREAM_DB_NAME]['users'][CREAM_DB_USER] = dict(
        'password', CREAM_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};

'/software/components/mysql/databases' = {
    SELF[DLG_DB_NAME]['server'] = CREAM_MYSQL_SERVER;
    SELF[DLG_DB_NAME]['initScript']['file'] = DLG_DB_INIT_SCRIPT;
    SELF[DLG_DB_NAME]['initOnce'] = true;
    SELF[DLG_DB_NAME]['users'][CREAM_DB_USER] = dict(
        'password', CREAM_DB_PASSWORD,
        'rights', list('ALL PRIVILEGES'),
    );
    SELF;
};

# Add a script for updating the database if necessary
include 'personality/cream_ce/upgrade_db';


@{
desc =  if true, configure a cron job to do the home directory cleanup of grid pool accounts
values = true or false
default = true if home directories are shared with WNs, else false
required = no
}
variable CREAM_HOMEDIR_CLEANUP ?= CE_SHARED_HOMES;
include if ( CREAM_HOMEDIR_CLEANUP ) 'personality/cream_ce/cleanup-accounts';


#------------------------------------------------------------------------------
# CREAM CE configuration file
#------------------------------------------------------------------------------

variable CREAM_CE_CONFIG = '/etc/glite-ce-cream/cream-config.xml';

variable CREAM_CE_CONFIG_CONTENTS = file_contents('personality/cream_ce/templates/cream-config.templ');

variable CEMON_URL = {
    if (CEMON_ENABLED) {
        "https://' + to_string(CEMON_HOST) + ':' + to_string(CEMON_PORT) + '/ce-monitor/services/CEMonitor";
    } else {
        "NA";
    };
};

variable CREAM_CE_CONFIG_CONTENTS = replace('CEMON_URL_VALUE', CEMON_URL, CREAM_CE_CONFIG_CONTENTS);

variable CEMON_ENABLED_PART = {
    contents = '    <parameter name="CREAM_JOB_SENSOR_HOST" value="' + to_string(CEMON_HOST) + '" />' + "\n";
    contents = contents + '    <parameter name="CREAM_JOB_SENSOR_PORT" value="9909" />' + "\n";
    contents;
};

variable CREAM_CE_CONFIG_CONTENTS = {
    if (CEMON_ENABLED) {
        replace('CEMON_ENABLED_PART', CEMON_ENABLED_PART, CREAM_CE_CONFIG_CONTENTS);
    } else {
        replace('CEMON_ENABLED_PART', '', CREAM_CE_CONFIG_CONTENTS);
    };
};

variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_DB_VERSION_VALUE', CREAM_DB_VERSION, CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_VAR_DIR_VALUE', CREAM_VAR_DIR, CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_SANDBOX_DIR_VALUE', CREAM_SANDBOX_DIR, CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CATALINA_HOME_VALUE', CATALINA_HOME, CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_DELEGATION_PURGE_RATE_VALUE', to_string(CREAM_DELEGATION_PURGE_RATE), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('BLAH_JOBID_PREFIX_VALUE', to_string(BLAH_JOBID_PREFIX), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_JOB_PURGE_RATE_VALUE', to_string(CREAM_JOB_PURGE_RATE), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_JOB_PURGE_POLICY_ABORTED_VALUE', to_string(CREAM_JOB_PURGE_POLICY_ABORTED), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_JOB_PURGE_POLICY_CANCELED_VALUE', to_string(CREAM_JOB_PURGE_POLICY_CANCELED), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_JOB_PURGE_POLICY_DONEOK_VALUE', to_string(CREAM_JOB_PURGE_POLICY_DONEOK), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_JOB_PURGE_POLICY_DONEFAILED_VALUE', to_string(CREAM_JOB_PURGE_POLICY_DONEFAILED), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_JOB_PURGE_POLICY_REGISTERED_VALUE', to_string(CREAM_JOB_PURGE_POLICY_REGISTERED), CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_DB_USER_VALUE', CREAM_DB_USER, CREAM_CE_CONFIG_CONTENTS);
variable CREAM_CE_CONFIG_CONTENTS = replace('CREAM_DB_PASSWORD_VALUE', CREAM_DB_PASSWORD, CREAM_CE_CONFIG_CONTENTS);

include 'components/filecopy/config';
"/software/components/filecopy/services" = npush(
    escape(CREAM_CE_CONFIG), dict(
        "config", CREAM_CE_CONFIG_CONTENTS,
        "owner", "root",
        "perms", "0644",
        "restart", "/sbin/service " + TOMCAT_SERVICE + " restart",
    ),
);

#------------------------------------------------------------------------------
# CEMonitor configuration file
#------------------------------------------------------------------------------
include if ( CEMON_ENABLED ) 'personality/cream_ce/cemonitor';


#------------------------------------------------------------------------------
# Configure CREAM-related directory and file permissions
#------------------------------------------------------------------------------

include 'components/dirperm/config';
'/software/components/dirperm/paths' = {
    # root
    append(dict(
        'path', '/etc/grid-security/admin-list',
        'owner', 'root:root',
        'perm', '0644',
        'type', 'f',
    ));
    append(dict(
        'path', GLITE_LOCATION + '/sbin/JobDBAdminPurger.sh',
        'owner', 'root:root',
        'perm', '0700',
        'type', 'f',
    ));

    # Tomcat
    append(dict(
        'path', CREAM_VAR_DIR,
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'perm', '0700',
        'type', 'd',
    ));
    append(dict(
        'path', CREAM_SANDBOX_DIR,
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'perm', '0755',
        'type', 'd',
    ));
    append(dict(
        'path', '/var/proxies',
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'perm', '0755',
        'type', 'd',
    ));
    append(dict(
        'path', CREAM_LOG_DIR,
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'perm', '0755',
        'type', 'd',
    ));
    append(dict(
        'path', GLITE_LOCATION + '/bin/glite_cream_load_monitor',
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'perm', '0700',
        'type', 'f',
    ));
};


#------------------------------------------------------------------------------
# Configure the Tomcat web services, including glexec
#------------------------------------------------------------------------------

"/software/components/symlink/links" = {
    # CREAM web service dependencies
    append(dict(
        "name", CATALINA_HOME + "/common/lib/mysql-connector-java.jar",
        "target", "/usr/share/java/mysql-connector-java.jar",
        "replace", dict("all", "yes"),
        "exists", true,
    ));
    append(dict(
        "name", CATALINA_HOME + "/lib/glite-lb-client-java.jar",
        "target", "/usr/lib/java/glite-lb-client-java.jar",
        "replace", dict("all", "yes"),
        "exists", true,
    ));
};


variable TOMCAT_GLEXEC_WRAPPER_FILE = '/usr/share/' + TOMCAT_SERVICE + '/glexec-wrapper.sh';
variable TOMCAT_GLEXEC_WRAPPER_CONTENTS = {
    contents = "#!/bin/sh\n";
    contents = contents + "/usr/sbin/glexec $@\n";
    contents;
};

"/software/components/filecopy/services" = npush(
    escape(TOMCAT_GLEXEC_WRAPPER_FILE), dict(
        "config", TOMCAT_GLEXEC_WRAPPER_CONTENTS,
        "owner", "root",
        "perms", "0644",
    )
);


# Configure /etc/tomcat6/server.xml
variable CRL_UPDATE_MILLIS ?= '3600000';
'/software/components/filecopy/services/{/etc/tomcat6/server.xml}' = {
    contents = <<EOT;
<Server port="8005" shutdown="SHUTDOWN">
  <Service name="Catalina">
    <Connector port="8443" SSLEnabled="true"
               maxThreads="150" minSpareThreads="25" maxSpareThreads="75"
               enableLookups="false" disableUploadTimeout="true"
               acceptCount="100" debug="0" scheme="https" secure="true"
               sSLImplementation="eu.emi.security.canl.tomcat.CANLSSLImplementation"
               truststore="X509_CERT_DIR"
               hostcert="TOMCAT_HOSTCERT_LOCATION"
               hostkey="TOMCAT_HOSTKEY_LOCATION"
               updateinterval="CRL_UPDATE_MILLIS"
               clientAuth="true" sslProtocol="TLS"
               crlcheckingmode="require"/>
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps" />
    </Engine>
  </Service>
</Server>
EOT
    contents = replace('X509_CERT_DIR', SITE_DEF_CERTDIR, contents);
    contents = replace('TOMCAT_HOSTCERT_LOCATION', TOMCAT_HOST_CERT, contents);
    contents = replace('TOMCAT_HOSTKEY_LOCATION', TOMCAT_HOST_KEY, contents);
    contents = replace('CRL_UPDATE_MILLIS', CRL_UPDATE_MILLIS, contents);
    dict(
        'config', contents,
        'owner', TOMCAT_USER + ':root',
        'perms', '0644',
        "restart", "/sbin/service " + TOMCAT_SERVICE + " restart",
    );
};

# Configure per-VO sandbox directories.
# Prior to CREAM 1.6, directory is created by the CE and thus tomcat
# user must belong to the VO groups to set the appropriate group
# ownership.
# With CREAM 1.6 and later, the top level directory must be created
# as part of the configuration.
"/software/components/dirperm/paths" = {
    foreach(k; vo; VOS) {
        append(dict(
            'path', CREAM_SANDBOX_DIR + '/' + vo,
            'owner', TOMCAT_USER + ':' + VO_INFO[vo]['group'],
            'perm', '0770',
            'type', 'd'
        ));
    };
    #create secondary groups sandbox dir, if those groups are used as primary  groups
    if (is_defined(VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP) && VO_FQAN_POOL_ACCOUNTS_USE_FQAN_GROUP) {
        foreach(k; vo; VOS) {
            if (is_defined(VO_INFO[vo]['accounts']['groups'])) {
                foreach(group; gid; VO_INFO[vo]['accounts']['groups']) {
                    append(dict(
                        'path', CREAM_SANDBOX_DIR + '/' + group,
                        'owner', TOMCAT_USER + ':' + group,
                        'perm', '0770',
                        'type', 'd'
                    ));
                };
            };
        };
    };
    SELF;
};

# Do a copy of machine cert/key for Tomcat usage
'/software/components/filecopy/services' = {
    SELF[escape(TOMCAT_HOST_KEY)] = dict(
        'source', SITE_DEF_HOST_KEY,
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'perms', '0400',
        'restart', '/sbin/service ' + TOMCAT_SERVICE + ' restart',
    );
    SELF[escape(TOMCAT_HOST_CERT)] = dict(
        'source', SITE_DEF_HOST_CERT,
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'perms', '0400',
        'restart', '/sbin/service ' + TOMCAT_SERVICE + ' restart',
    );
    SELF;
};


variable CREAM_CREAM_LOG4J_CONF = {
    root_logger = create('features/tomcat/root-logger');
    app_logger = create('personality/cream_ce/ce-cream-logger');
    app_logger['conf'] = replace(
        '%%LOGFILE%%',
        CREAM_LOG_DIR + '/glite-ce-cream.log',
        app_logger['conf']
    );
    config = root_logger['conf'] + "\n" + app_logger['conf'];
    config;
};
'/software/components/filecopy/services' = {
    SELF[escape(CREAM_CREAM_LOG4J_CONF_FILE)] = dict(
        'config', CREAM_CREAM_LOG4J_CONF,
        'owner', TOMCAT_USER + ':' + TOMCAT_GROUP,
        'restart', '/sbin/service ' + TOMCAT_SERVICE + ' restart',
    );
    SELF;
};


#------------------------------------------------------------------------------
# Configure sudo
#------------------------------------------------------------------------------

include 'personality/cream_ce/sudoers';

#
# Torque symlinks
#
variable TORQUE_COMMAND_LINKS ?= false;
include 'components/symlink/config';
"/software/components/symlink/links" = if (TORQUE_COMMAND_LINKS) {
    append(dict(
        "name", "/usr/bin/qstat",
        "target", "/usr/bin/qstat-torque",
        "replace", dict("link", "yes"),
        "exists", true,
    ));
    append(dict(
        "name", "/usr/bin/qsub",
        "target", "/usr/bin/qsub-torque",
        "replace", dict("link", "yes"),
        "exists", true,
    ));
    append(dict(
        "name", "/usr/bin/qhold",
        "target", "/usr/bin/qhold-torque",
        "replace", dict("link", "yes"),
        "exists", true,
    ));
    append(dict(
        "name", "/usr/bin/qrls",
        "target", "/usr/bin/qrls-torque",
        "replace", dict("link", "yes"),
        "exists", true,
    ));
    append(dict(
        "name", "/usr/bin/qalter",
        "target", "/usr/bin/qalter-torque",
        "replace", dict("link", "yes"),
        "exists", true,
    ));
    append(dict(
        "name", "/usr/bin/qselect",
        "target", "/usr/bin/qselect-torque",
        "replace", dict("link", "yes"),
        "exists", true,
    ));
    append(dict(
        "name", "/usr/bin/qdel",
        "target", "/usr/bin/qdel-torque",
        "replace", dict("link", "yes"),
        "exists", true,
    ));
} else {
    SELF;
};

