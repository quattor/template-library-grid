# Template for the configuration of glexec common to CE and WN

unique template features/glexec/base;

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
