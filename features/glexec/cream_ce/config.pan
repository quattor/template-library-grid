# Template for the configuration of glexec.

unique template features/glexec/cream_ce/config;

# Include configuration common to each glexec type
include { 'features/glexec/base' };

#-----------------------------------------------------------------------------
# glexec lcmaps configuration
#-----------------------------------------------------------------------------
include { 'features/lcmaps/glexec' };


#-----------------------------------------------------------------------------
# glexec lcas db file 
#-----------------------------------------------------------------------------
include { 'features/lcas/glexec' };


#-----------------------------------------------------------------------------
# /usr/sbin/glexec mode -> yaim/functions/config_cream_glexec
#-----------------------------------------------------------------------------
'/software/components/dirperm/paths' = {
  SELF[length(SELF)] = nlist('path', GLITE_LOCATION+'/sbin/glexec',
                             'owner', 'root:'+GLEXEC_GROUP,
                             'perm', '6555',
                             'type', 'f',
                            );

  SELF;
};


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

include { 'components/metaconfig/config' };

type glexec_main = {
  "linger"                           : string = "no"

  "lcmaps_db_file"                   : string = "/etc/lcmaps/lcmaps.db.glexec"
  "lcmaps_log_file"                  : string = "/var/log/glexec/lcas_lcmaps.log"
  "lcmaps_debug_level"               : long   = 0
  "lcmaps_log_level"                 : long   = 1

  "lcas_db_file"                     : string = "/etc/lcas/lcas-glexec.db"
  "lcas_log_file"                    : string = "/var/log/glexec/lcas_lcmaps.log"
  "lcas_debug_level"                 : long   = 0
  "lcas_log_level"                   : long   = 1

  "log_level"                        : long   = 1
  "create_target_proxy"              : string = "no"
  "user_identity_switch_by"          : string = "lcmaps"
  "user_white_list"                  : string = "tomcat"
  "ommission_private_key_white_list" : string = "tomcat"
  "preserve_env_variables"           : string = ""
  "silent_logging"                   : string = "no"
  "log_destination"                  : string = "file"
  "log_file"                         : string = "/var/log/glexec/glexec.log"
};

type glexec = {
  "glexec" : glexec_main
};

bind '/software/components/metaconfig/services/{/etc/glexec.conf.metaconfig}/contents' = glexec;

prefix '/software/components/metaconfig/services/{/etc/glexec.conf.metaconfig}';

'contents' = nlist('glexec',nlist());
'module'   = 'tiny';

'/software/packages/{perl-Config-Tiny}' = nlist();
