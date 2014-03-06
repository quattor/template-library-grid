# Template to do base configuration of tomcat5

unique template feature/tomcat5/config;

variable TOMCAT_SERVICE ?= 'tomcat5';

# Configure tomcat user.
# Define CATALINA_HOME based on TOMCAT_HOME: do not change default as
# several gLite configuration scripts make the assumption the default is used...
include { 'users/tomcat' };
variable CATALINA_HOME ?= TOMCAT_HOME;

# Options passed to Tomcat at startup.
# Set log4j.debug as a reminder this option can be used to debug log4j
# configuration issues...
variable CATALINA_OPTS ?= '-Dlog4j.debug=false';


# Define CATALINA_HOME in profile scripts
include { 'components/profile/config' };
'/software/components/profile/env/CATALINA_HOME' = CATALINA_HOME;

# Tomcat main log file.
# Do not change, except if you know what you are doing...
variable TOMCAT_LOG_FILE ?= CATALINA_HOME+'/logs/catalina.out';

# Enable/start tomcat5 service
"/software/components/chkconfig/service/tomcat5/on" = "";
"/software/components/chkconfig/service/tomcat5/startstop" = true;

# Define Java path, including a few paths required by startup script.
# JAVA_HOME must both be specified in sysconfig/tomcat5 for the startup
# script and in $CATALINA_HOME/bin/setenv.sh for Tomcat itself.
include { 'components/sysconfig/config' };
"/software/components/sysconfig/files/tomcat5/JAVA_HOME" = JAVA_LOCATION;
"/software/components/sysconfig/files/tomcat5/JRE_HOME" = JAVA_LOCATION;
"/software/components/sysconfig/files/tomcat5/JAVA_LIBDIR" = '/usr/share/java';
"/software/components/sysconfig/files/tomcat5/JNI_LIBDIR" = '/usr/share/java';
"/software/components/sysconfig/files/tomcat5/CATALINA_OPTS" = CATALINA_OPTS;
"/software/components/profile" = component_profile_add_env(CATALINA_HOME+'/bin/setenv.sh',
                                                           value('/software/components/sysconfig/files/tomcat5'),
                                                          );
# Ensure catalina.out is owned by Tomcat user.
# If created by the startup scipt, it is owned by root (tomcat 5.5.23).
'/software/components/dirperm/paths' = {
  SELF[length(SELF)] = nlist('path', TOMCAT_LOG_FILE,
                             'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                             'perm', '0644',
                             'type', 'f',
                            );
  SELF;
};

# Define log4j main logger configuration.
# Ignored if log4j is not used.
include { 'components/filecopy/config' };
# Ensure dirperm runs before filecopy to avoid tomcat startup errors
# because of inappropriate log file permissions.
'/software/components/filecopy/dependencies/pre' = push('dirperm');
variable TOMCAT_LOG4J_CONF = {
  root_logger = create('feature/tomcat5/root-logger');
  root_logger['conf'];
};
variable TOMCAT_LOG4J_CONF_FILE = CATALINA_HOME + '/common/classes/log4j.properties';
'/software/components/filecopy/services' = {
  SELF[escape(TOMCAT_LOG4J_CONF_FILE)] = nlist('config', TOMCAT_LOG4J_CONF,
                                               'owner', TOMCAT_USER+':'+TOMCAT_GROUP,
                                               'restart', '/sbin/service '+TOMCAT_SERVICE+' restart',
                                              );
  SELF;
};




