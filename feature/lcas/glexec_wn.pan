# glexec_wn-specific configuration of LCAS.
# This creates an additionnal LCAS db, in addition to the standard one.
# If the standard one has not yet been configured, it will be done.

unique template feature/lcas/glexec_wn;

# ---------------------------------------------------------------------------- 
# Include LCAS standard configuration
# ---------------------------------------------------------------------------- 
include { 'feature/lcas/base' };

variable LCAS_GLEXEC_DB_FILE ?= LCAS_CONFIG_DIR + '/lcas-glexec.db';

# ---------------------------------------------------------------------------- 
# First, build glexec LCAS configuration in variables
# ---------------------------------------------------------------------------- 
variable LCAS_GLEXEC_MODULES ?= {
  # Banned users.  Ensure DNs are double-quoted. 
  if (GLEXEC_SCAS_ENABLED || GLEXEC_ARGUS_ENABLED) {
    SELF['userban'] = LCAS_MODULES['userban'];
  } else {
    SELF['userban'] = LCAS_MODULES['userban'];
    SELF['voms'] = LCAS_MODULES['voms'];
  };

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
