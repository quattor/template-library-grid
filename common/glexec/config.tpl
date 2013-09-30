# Template for the configuration of glexec.

unique template common/glexec/config;

# glexec working directory
variable GLEXEC_VAR_DIR ?= '/var/glexec';

# Specifies where glexec logging should be done (syslog or file)
variable GLEXEC_LOG_DESTINATION ?= 'file';


# Glexec log files dir (used if GLEXEC_LOG_DESTINATION is file)
variable GLEXEC_LOG_DIR ?= '/var/log/glexec';

# Glexec log files name (used if GLEXEC_LOG_DESTINATION is file)
variable GLEXEC_LOG_FILE ?= 'glexec.log';

# glexec lcas-lcmaps log file (used if GLEXEC_LOG_DESTINATION is file)
variable GLEXEC_LCAS_LCMAPS_LOG_FILE ?= 'lcas_lcmaps.log';


#-----------------------------------------------------------------------------
# glexec user
#-----------------------------------------------------------------------------
include { 'users/glexec' };


#-----------------------------------------------------------------------------
# glexec lcmaps configuration
#-----------------------------------------------------------------------------
include { 'common/lcmaps/glexec' };


#-----------------------------------------------------------------------------
# glexec lcas db file 
#-----------------------------------------------------------------------------
include { 'common/lcas/glexec' };


#-----------------------------------------------------------------------------
# glexec configuration file
#-----------------------------------------------------------------------------
variable GLEXEC_CONF_FILE = GLITE_LOCATION + '/etc/glexec.conf';

variable GLEXEC_CONF_CONTENTS = {
  contents ='[glexec]' + "\n";
  contents = contents + 'linger = no' + "\n";
  contents = contents + "\n";
  contents = contents + 'lcmaps_db_file = ' + to_string(LCMAPS_GLEXEC_DB_FILE) + "\n";
  contents = contents + 'lcmaps_log_file = ' + GLEXEC_LOG_DIR + '/' + to_string(GLEXEC_LCAS_LCMAPS_LOG_FILE) + "\n";
  contents = contents + 'lcmaps_debug_level = 0' + "\n";
  contents = contents + 'lcmaps_log_level = 1' + "\n";
  contents = contents + "\n";
  contents = contents + 'lcas_db_file = ' + to_string(LCAS_GLEXEC_DB_FILE) + "\n";
  contents = contents + 'lcas_log_file = ' + GLEXEC_LOG_DIR + '/' + to_string(GLEXEC_LCAS_LCMAPS_LOG_FILE) + "\n";
  contents = contents + 'lcas_debug_level = 0' + "\n";
  contents = contents + 'lcas_log_level = 1' + "\n";
  contents = contents + "\n";
  contents = contents + 'log_level = 1' + "\n";
  contents = contents + 'user_identity_switch_by = lcmaps' + "\n";
  contents = contents + 'user_white_list = ' + to_string(TOMCAT_USER) + "\n";
  contents = contents + 'omission_private_key_white_list  = ' + to_string(TOMCAT_USER) + "\n";
  contents = contents + 'preserve_env_variables =' + "\n";
  contents = contents + 'silent_logging = no' + "\n";
  contents = contents + 'log_destination = ' + GLEXEC_LOG_DESTINATION + "\n";
    contents = contents + 'log_file = ' + GLEXEC_LOG_DIR + '/' + GLEXEC_LOG_FILE + "\n";

  contents;
};

"/software/components/filecopy/services" =
  npush(escape(GLEXEC_CONF_FILE),
        nlist("config",GLEXEC_CONF_CONTENTS,
              "owner","root:"+GLEXEC_GROUP,
              "perms","0640",
        )
  );


#-----------------------------------------------------------------------------
# Create some directories 
#-----------------------------------------------------------------------------

'/software/components/dirperm/paths' = {
  SELF[length(SELF)] = nlist('path', GLEXEC_VAR_DIR,
                             'owner', 'root:root',
                             'perm', '0755',
                             'type', 'd',
                            );
  SELF[length(SELF)] = nlist('path', GLEXEC_LOG_DIR,
                             'owner', 'root:root',
                             'perm', '0755',
                             'type', 'd',
                            );
  SELF[length(SELF)] = nlist('path', GLITE_LOCATION+'/sbin/glexec',
                             'owner', 'root:'+GLEXEC_GROUP,
                             'perm', '6555',
                             'type', 'f',
                            );
  SELF;
};
