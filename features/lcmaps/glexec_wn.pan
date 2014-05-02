# This template defines the LCMAPS configuration required for glexec_wn.
# Most variables controlling the configuration are defined as part of the glexec configuration.
# Based on CREAM CE configuration for glexec.
# It doesn't replace the standard LCMAPS configuration used by other services,
# which is included if not already done.

unique template feature/lcmaps/glexec_wn;

# ---------------------------------------------------------------------------- 
# Include standard LCMAPS configuration file after redefining
# policy order to match glexec-specific LCMAPS configuration file order
# ---------------------------------------------------------------------------- 

include { 'feature/lcmaps/base' };


# ---------------------------------------------------------------------------- 
# Build LCMAPS configuration in variables
# ---------------------------------------------------------------------------- 

# LCMAPS paths.
variable LCMAPS_GLEXEC_DB_FILE ?= LCMAPS_CONFIG_DIR+"/lcmaps.db.glexec";
variable LCMAPS_GLEXEC_MODULE_PATH ?= LCMAPS_LIB_DIR+"/lcmaps";

# Module definitions
variable LCMAPS_GLEXEC_MODULES ?= {
  SELF['verify_proxy'] = nlist();
  SELF['verify_proxy']['path'] = "lcmaps_verify_proxy.mod";
  SELF['verify_proxy']['args'] = " -certdir " + SITE_DEF_CERTDIR +
                                 " --allow-limited-proxy";

  if (GLEXEC_OPMODE != 'setuid' && !GLEXEC_ARGUS_ENABLED && !GLEXEC_SCAS_ENABLED) {
    SELF['good'] = nlist();
    SELF['good']['path'] = "lcmaps_dummy_good.mod";
    SELF['good']['args'] = " --dummy-username nobody" +
                           " --dummy-group nobody" +
                           " --dummy-sec-group nobody";

  } else {
    if ( GLEXEC_OPMODE == 'setuid' ) {
      SELF['posix_enf'] = nlist();
      SELF['posix_enf']['path'] = "lcmaps_posix_enf.mod";
      SELF['posix_enf']['args'] = " -maxuid 1" +
                                  " -maxpgid 1" +
                                  " -maxsgid 32";
    };

    if (!GLEXEC_ARGUS_ENABLED && !GLEXEC_SCAS_ENABLED) {
      SELF['vomslocalgroup'] = nlist();
      SELF['vomslocalgroup']['path'] = "lcmaps_voms_localgroup.mod";
      SELF['vomslocalgroup']['args'] = " -groupmapfile "+LCMAPS_CONFIG_DIR+"/groupmapfile" +
                                       " -mapmin 0 ";

      SELF['vomslocalaccount'] = nlist();
      SELF['vomslocalaccount']['path'] = "lcmaps_voms_localaccount.mod";
      SELF['vomslocalaccount']['args'] = " -gridmapfile "+LCMAPS_CONFIG_DIR+"/gridmapfile" +
                                         " -use_voms_gid "; 

      SELF['vomspoolaccount'] = nlist();
      SELF['vomspoolaccount']['path'] =  "lcmaps_voms_poolaccount.mod";
      SELF['vomspoolaccount']['args'] = " -gridmapfile "+LCMAPS_CONFIG_DIR+"/gridmapfile" +
                                        " -gridmapdir " + SITE_DEF_GRIDMAPDIR +
                                        " -do_not_use_secondary_gids";

      SELF['localaccount'] = nlist();
      SELF['localaccount']['path'] = "lcmaps_localaccount.mod";
      SELF['localaccount']['args'] = " -gridmapfile "+ SITE_DEF_GRIDMAP;
    
      SELF['poolaccount'] = nlist();
      SELF['poolaccount']['path'] = "lcmaps_poolaccount.mod";
      SELF['poolaccount']['args'] = " -override_inconsistency" +
                                    " -gridmapfile "+ SITE_DEF_GRIDMAP +
                                    " -gridmapdir "+ SITE_DEF_GRIDMAPDIR;
    } else {
      if (GLEXEC_SCAS_ENABLED) {
        SELF['scasclient'] = nlist();
        SELF['scasclient']['path'] = "lcmaps_scas_client.mod";
        scasclient_endpoints = "";
        sep = "";
        foreach(i;endpoint;GLEXEC_SCAS_ENDPOINTS) {
          scasclient_endpoints = scasclient_endpoints + sep + "--endpoints " + endpoint;
          sep = "\n";
        };
        SELF['scasclient']['args'] = " -capath " + SITE_DEF_CERTDIR +
                                     scasclient_endpoints +
                                     " -resourcetype wn" +
                                     " -actiontype execute-now";
      };

      if (GLEXEC_ARGUS_ENABLED) {
        SELF['pepc'] = nlist();
        SELF['pepc']['path'] = "lcmaps_c_pep.mod";
        pepc_endpoints = "";
        sep = "";
        foreach(i;endpoint;GLEXEC_ARGUS_PEPD_ENDPOINTS) {
          pepc_endpoints = pepc_endpoints + sep + "--pep-daemon-endpoint-url " + endpoint;
          sep = "\n";
        };
        if ( OS_VERSION_PARAMS['major'] == 'sl6' ) {
          pep_os_params = ' --use-pilot-proxy-as-cafile'
        } else {
          pep_os_params = '';
        };
        SELF['pepc']['args'] = pepc_endpoints +
                               " -resourceid " + GLEXEC_PEPC_RESOURCEID +
                               " -actionid " + GLEXEC_PEPC_ACTIONID +
                               " -capath " + SITE_DEF_CERTDIR +
                               " -pep-certificate-mode implicit"+
                               +pep_os_params;
      };
    };
  };

  SELF;
};

# Policies.
variable LCMAPS_GLEXEC_POLICIES ?= {
  if (GLEXEC_OPMODE != 'setuid' && !GLEXEC_ARGUS_ENABLED && !GLEXEC_SCAS_ENABLED) {
    list(
      nlist("name", "glexec_get_account",
            "ruleset", list("verify_proxy -> good",)
      ),
    );
  } else {
    if (!GLEXEC_ARGUS_ENABLED && !GLEXEC_SCAS_ENABLED) {
      list(
        nlist("name", "glexec_get_account",
              "ruleset", list("verify_proxy -> vomslocalgroup",
                              "vomslocalgroup -> vomslocalaccount | localaccount",
                              "vomslocalaccount -> posix_enf | vomspoolaccount",
                              "vomspoolaccount -> posix_enf",
                              "localaccount -> posix_enf | poolaccount",
                              "poolaccount -> posix_end",)
        ),
      );
    } else {
      if ( GLEXEC_ARGUS_ENABLED && !GLEXEC_SCAS_ENABLED) {
        if ( GLEXEC_OPMODE == 'setuid') {
          list(
            nlist("name", "glexec_get_account",
                  "ruleset", list("verify_proxy -> pepc",
                                  "pepc -> posix_enf")
            ),
          );
        } else {
          list(
            nlist("name", "glexec_get_account",
                  "ruleset", list("verify_proxy -> pepc",)
            ),
          );
        };
      } else if ( !GLEXEC_ARGUS_ENABLED && GLEXEC_SCAS_ENABLED ) {
        if ( GLEXEC_OPMODE == 'setuid' ) {
          list(
            nlist("name", "glexec_get_account",
                  "ruleset", list("verify_proxy -> scasclient",
                                  "scasclient -> poxix_enf")
            ),
          );
        } else {
          list(
            nlist("name", "glexec_get_account",
                  "ruleset", list("verify_proxy -> scasclient",)
            ),
          );
        };
      } else {
        if ( GLEXC_OPMODE == 'setuid' ) {
          list(
            nlist("name", "glexec_get_account",
                  "ruleset", list("verify_proxy -> pepc",
                                  "pepc -> scasclient",
                                  "scasclient -> posix_enf")
            ),
          );
        } else {
          list(
            nlist("name", "glexec_get_account",
                  "ruleset", list("verify_proxy -> pepc",
                                  "pepc -> scasclient",)
            ),
          );
        };
      };
    };
  };
};


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

