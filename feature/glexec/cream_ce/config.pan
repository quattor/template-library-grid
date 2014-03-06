# Template for the configuration of glexec.

unique template feature/glexec/cream_ce/config;

# Include configuration common to each glexec type
include { 'feature/glexec/base' };

#-----------------------------------------------------------------------------
# glexec lcmaps configuration
#-----------------------------------------------------------------------------
include { 'feature/lcmaps/glexec' };


#-----------------------------------------------------------------------------
# glexec lcas db file 
#-----------------------------------------------------------------------------
include { 'feature/lcas/glexec' };


#-----------------------------------------------------------------------------
# glexec configuration file
#-----------------------------------------------------------------------------
variable GLEXEC_CONF_FILE = EMI_LOCATION + '/etc/glexec.conf';

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
  contents = contents + "create_target_proxy = no\n";
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

