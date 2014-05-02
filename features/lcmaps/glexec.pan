# This template defines the LCMAPS configuration required for glexec.
# Based on CREAM CE configuration for glexec.
# It doesn't replace the standard LCMAPS configuration used by other services,
# which is included if not already done.

unique template features/lcmaps/glexec;

# ---------------------------------------------------------------------------- 
# Include standard LCMAPS configuration file after redefining
# policy order to match glexec-specific LCMAPS configuration file order
# ---------------------------------------------------------------------------- 


include { 'features/lcmaps/base' };


# ---------------------------------------------------------------------------- 
# Build LCMAPS configuration in variables
# ---------------------------------------------------------------------------- 

# LCMAPS paths.
variable LCMAPS_GLEXEC_DB_FILE ?= LCMAPS_CONFIG_DIR+"/lcmaps.db.glexec";
variable LCMAPS_GLEXEC_MODULE_PATH ?= LCMAPS_LIB_DIR+"/lcmaps";

# Module definitions
variable LCMAPS_GLEXEC_MODULES ?= {

  SELF['localaccount'] = nlist();
  SELF['localaccount']['path'] = "lcmaps_localaccount.mod";
  SELF['localaccount']['args'] = " -gridmapfile "+ SITE_DEF_GRIDMAP;

  SELF['poolaccount'] = nlist();
  SELF['poolaccount']['path'] = "lcmaps_poolaccount.mod";
  SELF['poolaccount']['args'] = " -override_inconsistency" +
                                " -gridmapfile "+ SITE_DEF_GRIDMAP +
                                " -gridmapdir "+ SITE_DEF_GRIDMAPDIR;

  SELF['vomslocalgroup'] = nlist();
  SELF['vomslocalgroup']['path'] = "lcmaps_voms_localgroup.mod";
  SELF['vomslocalgroup']['args'] = " -groupmapfile "+LCMAPS_CONFIG_DIR+"/groupmapfile" +
                                   " -mapmin 0 ";

  SELF['vomspoolaccount'] = nlist();
  SELF['vomspoolaccount']['path'] =  "lcmaps_voms_poolaccount.mod";
  SELF['vomspoolaccount']['args'] = " -gridmapfile "+LCMAPS_CONFIG_DIR+"/gridmapfile" +
                                    " -gridmapdir "+ SITE_DEF_GRIDMAPDIR+
                                    " -override_inconsistency";

  SELF['vomslocalaccount'] = nlist();
  SELF['vomslocalaccount']['path'] = "lcmaps_voms_localaccount.mod";
  SELF['vomslocalaccount']['args'] = " -gridmapfile "+LCMAPS_CONFIG_DIR+"/gridmapfile";


  SELF['proxycheck'] = nlist();
  SELF['proxycheck']['path'] = "lcmaps_verify_proxy.mod";
  SELF['proxycheck']['args'] = " -certdir "+ SITE_DEF_CERTDIR;

  SELF['posixenf'] = nlist();
  SELF['posixenf']['path'] = "lcmaps_posix_enf.mod";
  SELF['posixenf']['args'] = " -maxuid 1" +
                             " -maxpgid 1" +
                             " -maxsgid 32";

  if ( LCMAPS_ADD_GIDS_FROM_MAPPED_ACCOUNTS ) {
    SELF['vomspoolaccount']['args'] = SELF['vomspoolaccount']['args']+
                                      " --add-primary-gid-from-mapped-account"+
                                      " --add-secondary-gids-from-mapped-account";

    SELF['vomslocalgroup']['args'] = SELF['vomslocalgroup']['args']+
                                     " --map-to-secondary-groups";
  } else {
    SELF['vomslocalaccount']['args'] = SELF['vomslocalaccount']['args'] + " -use_voms_gid ";
  };
  SELF;
};

# Policies.
variable LCMAPS_GLEXEC_POLICIES ?= list (
     nlist(
           "name", "voms",
           "ruleset", list ("proxycheck -> vomslocalgroup",
                            "vomslocalgroup -> vomslocalaccount",
                            "vomslocalaccount -> posixenf | vomspoolaccount",
                            "vomspoolaccount -> posixenf",
                            )
          ),
     nlist(
           "name", "standard",
           "ruleset", list ("proxycheck -> localaccount",
                            "localaccount -> posixenf | poolaccount",
                            "poolaccount -> posixenf",
                           )
          ),
);

# ---------------------------------------------------------------------------- 
# Add LCMAPS configuration to ncm-lcmaps configuration, taking care that
# several LCMAPS configuration can coexist on one node.
# ---------------------------------------------------------------------------- 
include { 'components/lcmaps/config' };
'/software/components/lcmaps/config' = {
  if ( is_list(SELF) ) {
    config_len = length(SELF);
  } else {
    config_len = 0;
  };
  SELF[config_len]['dbpath'] = LCMAPS_GLEXEC_DB_FILE;
  SELF[config_len]['modulepath'] = LCMAPS_GLEXEC_MODULE_PATH;
  SELF[config_len]['module'] = LCMAPS_GLEXEC_MODULES;
  SELF[config_len]['policies'] = LCMAPS_GLEXEC_POLICIES;
  SELF;
};


# ---------------------------------------------------------------------------- 
# Define LCMAPS debug and logging level (default is very verbose)
# ---------------------------------------------------------------------------- 
include { 'components/profile/config' };
'/software/components/profile' = component_profile_add_env(GLITE_GRID_ENV_PROFILE,
                                                           nlist('LCMAPS_DEBUG_LEVEL', to_string(LCMAPS_DEBUG_LEVEL),
                                                                 'LCMAPS_LOG_LEVEL', to_string(LCMAPS_LOG_LEVEL),
                                                                )
                                                          );

