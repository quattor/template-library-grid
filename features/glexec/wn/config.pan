# Template for the configuration of glexec.

unique template features/glexec/wn/config;

variable GLEXEC_WN_ENABLED ?= true;
variable GLEXEC_OPMODE ?= 'setuid';
variable GLEXEC_ARGUS_ENABLED ?= true;
variable GLEXEC_SCAS_ENABLED ?= false;

variable DEBUG = {
  debug(OBJECT+': GLEXEC_WN_ENABLED='+to_string(GLEXEC_WN_ENABLED)+', GLEXEC_OPMODE='+to_string(GLEXEC_OPMODE));
  debug(OBJECT+': GLEXEC_ARGUS_ENABLED='+to_string(GLEXEC_ARGUS_ENABLED)+', GLEXEC_SCAS_ENABLED='+to_string(GLEXEC_SCAS_ENABLED));
};

variable GLEXEC_ARGUS_PEPD_ENDPOINTS ?= if ( GLEXEC_ARGUS_ENABLED ) {
                                          error('No ARGUS PEPD endpoint (GLEXEC_ARGUS_PEPD_ENDPOINTS) defined whilst GLEXEC_ARGUS_ENABLED=true');
                                        } else {
                                          undef;
                                        };
# Include configuration common to each glexec type
include { 'features/glexec/base' };

# Define the list of SCAS endpoints if glexec is a SCAS client
# e.g. list('https://scas1.example.com:8443').
variable GLEXEC_SCAS_ENDPOINTS ?= {
  if (GLEXEC_SCAS_ENABLED) {
    error('SCAS is enabled, but no endpoints are configured');
  } else {
    undef;
  };
};

variable GLEXEC_PEPC_RESOURCEID ?= "http://authz-interop.org/xacml/resource/resource-type/wn";

variable GLEXEC_PEPC_ACTIONID ?= "http://glite.org/xacml/action/execute";

# List of account names or pool account representations (e.g. ".ops") to add
# to the glexec user white list.
variable GLEXEC_EXTRA_WHITELIST ?= list();

# The list of user that will be allowed to execute glexec
variable GLEXEC_USER_LIST ?= {
  userlist = '';
  foreach(i;vo;VOS) {
    if ( is_defined(VO_INFO[vo]['group']) && is_defined(VO_INFO[vo]['accounts']['users']) ) {
      foreach (username;userinfo;VO_INFO[vo]['accounts']['users']) {
        if ( match(username, 'pilot$') ) {
          if (exists(userinfo['poolSize'])) {
            poolStart = to_long(userinfo['poolStart']);
            poolSize = to_long(userinfo['poolSize']);
            poolDigits = to_long(userinfo['poolDigits']);
            if (poolSize > 0) {
              poolEnd = poolStart + poolSize - 1;
            } else {
              poolEnd = poolStart;
            };
            suffix_format = "%0" + to_string(poolDigits) + "d";
            k = poolStart;
            while (k <= poolEnd) {
              uname = to_string(username) + format(suffix_format,k);
              userlist = userlist + uname + ',';
              k = k + 1;
            };
          } else {
            uname = to_string(username);
            userlist = userlist + uname + ',';
          };
        };
      };
    };
  };
  foreach(i;username;GLEXEC_EXTRA_WHITELIST) {
    userlist = userlist + to_string(username) + ',';
  };
  userlist = replace(',$','',userlist);

  userlist;
};

# Method used for target proxy file locking; allowed values are flock, fcntl,
# disabled. Flock does not work on NFS, while fcntl may cause problems on
# older kernels.
variable GLEXEC_TARGET_LOCK = {
  if ( is_defined(GLEXEC_TARGET_LOCK) && (GLEXEC_TARGET_LOCK != ''))  {
    if ( GLEXEC_TARGET_LOCK == 'flock' || GLEXEC_TARGET_LOCK == 'fcntl' || GLEXEC_TARGET_LOCK == 'disabled') {
      GLEXEC_TARGET_LOCK;
    } else {
      error("The value for GLEXEC_TARGET_LOCK is incorrect (" + GLEXEC_TARGET_LOCK + "). The value should be 'flock','fcntl' or 'disabled'.");
    };
  } else {
    '';
  };
};

# Method used for input proxy file locking; allowed values are flock, fcntl,
# disabled. Flock does not work on NFS, while fcntl may cause problems on
# older kernels.
variable GLEXEC_INPUT_LOCK ?= {
  if ( is_defined(GLEXEC_INPUT_LOCK) && (GLEXEC_INPUT_LOCK != ''))  {
    if ( GLEXEC_INPUT_LOCK == 'flock' || GLEXEC_INPUT_LOCK == 'fcntl' || GLEXEC_INPUT_LOCK == 'disabled') {
      GLEXEC_INPUT_LOCK;
    } else {
      error("The value for GLEXEC_INOPUT_LOCK is incorrect (" + GLEXEC_INPUT_LOCK + "). The value should be 'flock','fcntl' or 'disabled'.");
    };
  } else {
    '';
  };
};

#-----------------------------------------------------------------------------
# glexec lcmaps configuration
#-----------------------------------------------------------------------------

include { 'features/lcmaps/glexec_wn' };


#-----------------------------------------------------------------------------
# glexec lcas db file
#-----------------------------------------------------------------------------
include { 'features/lcas/glexec_wn' };


#-----------------------------------------------------------------------------
# glexec configuration file
#-----------------------------------------------------------------------------

variable GLEXEC_CONF_FILE = '/etc/glexec.conf';

variable GLEXEC_CONF_CONTENTS = {
  contents ='[glexec]' + "\n";
  contents = contents + 'silent_logging = no' + "\n";
  contents = contents + 'log_level = 1' + "\n";
  contents = contents + 'user_white_list = ' + GLEXEC_USER_LIST + "\n";
  contents = contents + 'linger = yes' + "\n";
  if (GLEXEC_TARGET_LOCK != '') {
    contents = contents + 'target_lock_mechanism = ' + GLEXEC_TARGET_LOCK + "\n";
  };
  if (GLEXEC_INPUT_LOCK != '') {
    contents = contents + 'input_lock_mechanism = ' + GLEXEC_INPUT_LOCK + "\n";
  };
  contents = contents + "\n";
  contents = contents + 'lcmaps_db_file = ' + to_string(LCMAPS_GLEXEC_DB_FILE) + "\n";
  contents = contents + 'lcmaps_log_file = ' + GLEXEC_LOG_DIR + '/' + to_string(GLEXEC_LCAS_LCMAPS_LOG_FILE) + "\n";
  contents = contents + 'lcmaps_debug_level = 0' + "\n";
  contents = contents + 'lcmaps_log_level = 1' + "\n";
  contents = contents + 'lcmaps_get_account_policy = glexec_get_account' + "\n";
  contents = contents + 'lcmaps_verify_account_policy = glexec_verify_account' + "\n";
  contents = contents + "\n";
  contents = contents + 'lcas_db_file = ' + to_string(LCAS_GLEXEC_DB_FILE) + "\n";
  contents = contents + 'lcas_log_file = ' + GLEXEC_LOG_DIR + '/' + to_string(GLEXEC_LCAS_LCMAPS_LOG_FILE) + "\n";
  contents = contents + 'lcas_debug_level = 0' + "\n";
  contents = contents + 'lcas_log_level = 1' + "\n";
  contents = contents + "\n";
  contents = contents + 'user_identity_switch_by = lcmaps' + "\n";
  contents = contents + 'preserve_env_variables = no' + "\n";
  if (GLEXEC_LOG_DESTINATION == 'syslog') {
    contents = contents + 'log_destination = ' + GLEXEC_LOG_DESTINATION + "\n";
  } else if (GLEXEC_LOG_DESTINATION == 'file' && GLEXEC_OPMODE == 'setuid') {
    contents = contents + 'log_destination = ' + GLEXEC_LOG_DESTINATION + "\n";
    contents = contents + 'log_file = ' + GLEXEC_LOG_DIR + '/' + GLEXEC_LOG_FILE + "\n";
  } else if (GLEXEC_LOG_DESTINATION == 'file' && GLEXEC_OPMODE == 'log-only') {
    error('glexec is configured to work in logging only mode. GLEXEC_LOG_DESTINATION should be syslog');
  };

  contents;
};

variable GLEXEC_FILE_PERMS = {
  if (GLEXEC_OPMODE == 'setuid') {
    "0640";
  } else {
    "0644";
  };
};

"/software/components/filecopy/services" =
  npush(escape(GLEXEC_CONF_FILE),
        nlist("config",GLEXEC_CONF_CONTENTS,
              "owner","root:"+GLEXEC_GROUP,
              "perms",GLEXEC_FILE_PERMS,
        )
  );

"/software/components/dirperm/paths" =
  push(nlist('path',LCAS_GLEXEC_DB_FILE,
             'owner','root:root',
             'perm',GLEXEC_FILE_PERMS,
             'type', 'f',
            )
      );

'/software/components/dirperm/paths' = {
  if (GLEXEC_OPMODE=="setuid") {
    SELF[length(SELF)] = nlist('path', GLITE_LOCATION+'/sbin/glexec',
                               'owner', 'root:'+GLEXEC_GROUP,
                               'perm', '6111',
                               'type', 'f',
                              );
  } else {
    SELF[length(SELF)] = nlist('path', GLITE_LOCATION+'/sbin/glexec',
                               'owner', 'root:'+GLEXEC_GROUP,
                               'perm', '0555',
                               'type', 'f',
                             );
  };

  SELF;
};
