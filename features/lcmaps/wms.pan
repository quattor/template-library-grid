# This template is required to configure LCMAPS for EMI-1 WMS
# It is based on lcmaps.db.template provided by RPM glite-wms-wmproxy-3.1.26-1.
#
# Note that the standard lcmaps configuration must also be installed for
# GridFTP... 

unique template features/lcmaps/wms;

include { 'features/lcmaps/base' };

# ---------------------------------------------------------------------------- 
# Build LCMAPS configuration in variables
# ---------------------------------------------------------------------------- 

# LCMAPS paths.
# Be careful with changing these parameters.  When using a non default name,
# environment variable LCMAPS_DB_FILE must be defined.

#THIS file is going to be used by the WMS gridftp

variable LCMAPS_WMS_DB_FILE ?= LCMAPS_CONFIG_DIR+"/lcmaps.db";
variable LCMAPS_GRIDFTP_DB_FILE ?= LCMAPS_CONFIG_DIR+"/lcmaps.db.gridftp";


#-----------------------------------------------------------------------------
# Configuration of WMS LCMAPS DB
#-----------------------------------------------------------------------------

variable LCMAPS_WMS_MODULES ?= {
  SELF['good'] = nlist();
  SELF['good']['path'] = "lcmaps_dummy_good.mod";

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
                                    " -do_not_use_secondary_gids";

  SELF['vomslocalaccount'] = nlist();
  SELF['vomslocalaccount']['path'] = "lcmaps_voms_localaccount.mod";
  SELF['vomslocalaccount']['args'] = " -gridmapfile "+LCMAPS_CONFIG_DIR+"/gridmapfile" +
                                     " -use_voms_gid ";

  SELF;
};

variable LCMAPS_WMS_POLICIES ?= list (
     nlist(
           "name", "standard",
           "ruleset", list ("localaccount -> good | poolaccount",
                            "poolaccount -> good",
                           )
          ),
     nlist(
           "name", "voms",
           "ruleset", list ("localaccount -> good | poolaccount",
                            "poolaccount -> good | vomslocalgroup",
                            "vomslocalgroup -> vomspoolaccount",
                            )
          ),
);


#-----------------------------------------------------------------------------
# Configuration of GRIDFTP LCMAPS DB
#-----------------------------------------------------------------------------

variable LCMAPS_GRIDFTP_MODULES ?= {
  SELF['posix_enf'] = nlist();
  SELF['posix_enf']['path'] = "lcmaps_posix_enf.mod";
  SELF['posix_enf']['args'] = " -maxuid 1" +
                              " -maxpgid 1" +
                              " -maxsgid 32";

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

  SELF['vomslocalaccount'] = nlist();
  SELF['vomslocalaccount']['path'] = "lcmaps_voms_localaccount.mod";
  SELF['vomslocalaccount']['args'] = " -gridmapfile "+LCMAPS_CONFIG_DIR+"/gridmapfile" +
                                     " -use_voms_gid ";

  SELF['vomspoolaccount'] = nlist();
  SELF['vomspoolaccount']['path'] =  "lcmaps_voms_poolaccount.mod";
  SELF['vomspoolaccount']['args'] = " -gridmapfile "+LCMAPS_CONFIG_DIR+"/gridmapfile" +
                                    " -gridmapdir "+ SITE_DEF_GRIDMAPDIR+
                                    " -do_not_use_secondary_gids";

  SELF['good'] = nlist();
  SELF['good']['path'] = "lcmaps_dummy_good.mod";

  SELF;
};

variable LCMAPS_GRIDFTP_POLICIES ?= list (
     nlist(
           "name", "standard",
           "ruleset", list ("localaccount -> posix_enf | poolaccount",
                            "poolaccount -> posix_enf",
                           )
          ),
     nlist(
           "name", "withvoms",
           "ruleset", list ("vomslocalgroup -> vomslocalaccount",
                            "vomslocalaccount -> posix_enf | vomspoolaccount",
                            "vomspoolaccount -> posix_enf",
                            )
          ),
);


# ---------------------------------------------------------------------------- 
# Add LCMAPS configuration to ncm-lcmaps configuration, taking care that
# several LCMAPS configuration can coexist on one node.
# ---------------------------------------------------------------------------- 

include { 'components/lcmaps/config' };

'/software/components/lcmaps/config' = {
  lcmaps_config = list();
  if ( is_list(SELF) ) {
    # Replace default gridftp config
    foreach(i;config_details;SELF) {
      if ((config_details['dbpath']!=LCMAPS_WMS_DB_FILE) && (config_details['dbpath']!=LCMAPS_GRIDFTP_DB_FILE)) {
        lcmaps_config = append(lcmaps_config,config_details);
      };
    };
    lcmaps_config;
    config_len = length(lcmaps_config);
  } else {
    config_len = 0;
  };

  lcmaps_config[config_len]['dbpath'] = LCMAPS_WMS_DB_FILE;
  lcmaps_config[config_len]['modulepath'] = LCMAPS_MODULE_PATH;
  lcmaps_config[config_len]['module'] = LCMAPS_WMS_MODULES;
  lcmaps_config[config_len]['policies'] = LCMAPS_WMS_POLICIES;

  config_len = config_len + 1;

  lcmaps_config[config_len]['dbpath'] = LCMAPS_GRIDFTP_DB_FILE;
  lcmaps_config[config_len]['modulepath'] = LCMAPS_MODULE_PATH;
  lcmaps_config[config_len]['module'] = LCMAPS_GRIDFTP_MODULES;
  lcmaps_config[config_len]['policies'] = LCMAPS_GRIDFTP_POLICIES;

  lcmaps_config;
};

