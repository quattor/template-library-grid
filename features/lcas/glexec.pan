# glexec-specific configuration of LCAS.
# This creates an additionnal LCAS db, in addition to the standard one.
# If the standard one has not yet been configured, it will be done.

unique template features/lcas/glexec;

variable LCAS_GLEXEC_DB_FILE ?= LCAS_CONFIG_DIR + '/lcas-glexec.db';

variable LCAS_GLEXEC_ALLOWED_EXEC_PREFIX = {
    if (is_defined(CE_BATCH_SYS)) {
        CE_BATCH_SYS;
    } else {
        error("CE_BATCH_SYS variable need to be defined to compute LCAS_GLEXEC_ALLOWED_EXEC_PREFIX")
    };
};

# Executables allowed with glexec
variable LCAS_GLEXEC_ALLOWED_EXEC ?= list('/bin/cat',
                                          '/bin/cp',
                                          '/bin/echo',
                                          '/bin/kill',
                                          '/bin/pwd',
                                          '/bin/rm',
                                          '/usr/bin/groups',
                                          '/usr/bin/id',
                                          '/usr/bin/readlink',
                                          '/usr/bin/whoami',
                                          '/usr/bin/BPRclient',
                                          '/usr/bin/blah_job_registry_lkup',
                                          '/usr/bin/'+LCAS_GLEXEC_ALLOWED_EXEC_PREFIX+'_submit.sh',
                                          '/usr/bin/'+LCAS_GLEXEC_ALLOWED_EXEC_PREFIX+'_status.sh',
                                          '/usr/bin/'+LCAS_GLEXEC_ALLOWED_EXEC_PREFIX+'_cancel.sh',
                                          '/usr/bin/'+LCAS_GLEXEC_ALLOWED_EXEC_PREFIX+'_hold.sh',
                                          '/usr/bin/'+LCAS_GLEXEC_ALLOWED_EXEC_PREFIX+'_resume.sh',
                                          '/usr/bin/glite-cream-createsandboxdir',
                                          '/etc/glite-ce-cream/cream-glexec.sh',
                                         );

# ---------------------------------------------------------------------------- 
# Include LCAS standard configuration
# ---------------------------------------------------------------------------- 
include { 'features/lcas/base' };
 
# ---------------------------------------------------------------------------- 
# First, build glexec LCAS configuration in variables
# ---------------------------------------------------------------------------- 

# Module definitions.
# Module order has no impact on LCAS decisions: use a nlist for easy tweaking of module parameters in
# other templates.
variable LCAS_GLEXEC_MODULES ?= {
  # VOMS users: reuse standard config
  SELF['voms'] = LCAS_MODULES['voms'];

  # Module to check executable
  valid_executables = '';
  foreach (i;executable;LCAS_GLEXEC_ALLOWED_EXEC) {
    valid_executables = valid_executables + executable + ':';
  };
  valid_executables = replace(':$','',valid_executables);
  SELF['checkexecutable'] = nlist();
  SELF['checkexecutable']['path'] = LCAS_MODULE_PATH+"/lcas_check_executable.mod";
  SELF['checkexecutable']['args'] = '"-exec '+valid_executables+'"';
    
  SELF;
};


# ---------------------------------------------------------------------------- 
# Add LCAS configuration to ncm-lcas configuration, taking care that
# several LCAS configuration can coexist on one node.
# ---------------------------------------------------------------------------- 
include { 'components/lcas/config' };
'/software/components/lcas/db' = {
  if ( is_list(SELF) ) {
    config_len = length(SELF);
  } else {
    config_len = 0;
  };
  SELF[config_len] = nlist();
  SELF[config_len]['path'] = LCAS_GLEXEC_DB_FILE;
  SELF[config_len]['module'] = list();
  foreach (plugin;params;LCAS_GLEXEC_MODULES) {
    SELF[config_len]['module'][length(SELF[config_len]['module'])] = params;
  };
  debug('LCAS databases: '+to_string(SELF));
  SELF;
};


# ---------------------------------------------------------------------------- 
# Define LCAS debug and logging level (default is very verbose)
# ---------------------------------------------------------------------------- 
include { 'components/profile/config' };
'/software/components/profile' = component_profile_add_env(GLITE_GRID_ENV_PROFILE,
                                                           nlist('LCAS_DEBUG_LEVEL', to_string(LCAS_DEBUG_LEVEL),
                                                                 'LCAS_LOG_LEVEL', to_string(LCAS_LOG_LEVEL),
                                                               )
                                                          );
