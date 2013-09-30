# This template defines Condor config for use by Resource Broker and gLite WMS

unique template common/condor/config;

variable CONDOR_VERSION ?= null;


# Define some variables according to WMS/RB flavor
variable CONDOR_USER ?= if ( WMS_FLAVOR == 'glite' ) {
                          return('glite');
                        } else {
                          return('edguser');
                        };
variable CONDOR_GROUP ?= CONDOR_USER;


# Define Condor related paths
variable CONDOR_INSTALL_PATH ?= if ( exists(CONDOR_INSTALL_PATH) && is_defined(CONDOR_INSTALL_PATH) ) {
                                  return(SELF);
                                } else if ( exists(CONDOR_VERSION) && is_defined(CONDOR_VERSION) ) {
                                  return(INSTALL_ROOT+"/condor-"+CONDOR_VERSION);
                                } else {
                                  return(INSTALL_ROOT+"/condor");
                                };
variable CONDOR_CONFIG_FILE ?= CONDOR_INSTALL_PATH+"/etc/condor_config";
variable CONDOR_VAR_DIR ?= "/var/condor";


# ---------------------------------------------------------------------------- 
# condorconfig
# ---------------------------------------------------------------------------- 
include { 'components/condorconfig/config' };

"/software/components/condorconfig/configFile" = CONDOR_CONFIG_FILE;
"/software/components/condorconfig/RELEASE_DIR" = CONDOR_INSTALL_PATH;
"/software/components/condorconfig/user" = CONDOR_USER;
"/software/components/condorconfig/CONDOR_ADMIN" = SITE_EMAIL;
"/software/components/condorconfig/LOCAL_DIR" = CONDOR_VAR_DIR;


# ---------------------------------------------------------------------------- 
# dirperm
# ---------------------------------------------------------------------------- 
include { 'components/dirperm/config' };

# Add ncm-accounts as a pre dependency for ncm-dirperm
"/software/components/dirperm/dependencies/pre" = {
  if ( !exists(SELF) ||
       !is_defined(SELF) ||
       !is_list(SELF) ) {
    return(list('accounts'));
  } else {
    found = false;
    dependencies = SELF;
    ok = first(dependencies, i, v);
    while (ok) {
      if ( v == 'accounts' ) {
        found = true;
      };
      ok = next(dependencies, i, v);
    };
    if ( ! found ) {
      dependencies[length(dependencies)] = 'accounts';
    };
    return(dependencies);
  };

};

"/software/components/dirperm/paths" =
  push(
    nlist(
      "path", CONDOR_VAR_DIR+"/log",
      "owner", CONDOR_USER+":"+CONDOR_GROUP,
      "perm", "0755",
      "type", "d")
  );

"/software/components/dirperm/paths" =
  push(
    nlist(
      "path", CONDOR_VAR_DIR+"/log/GridLogs",
      "owner", CONDOR_USER+":"+CONDOR_GROUP,
      "perm", "0755",
      "type", "d")
  );

"/software/components/dirperm/paths" =
  push(
    nlist(
      "path", CONDOR_VAR_DIR+"/spool",
      "owner", CONDOR_USER+":"+CONDOR_GROUP,
      "perm", "0755",
      "type", "d")
  );


# ----------------------------------------------------------------------------
# sysconfig
# ----------------------------------------------------------------------------
include { 'components/sysconfig/config' };
'/software/components/sysconfig/files/globus/CONDORG_INSTALL_PATH' = CONDOR_INSTALL_PATH;
'/software/components/sysconfig/files/globus/CONDOR_CONFIG'         = CONDOR_CONFIG_FILE;


# Flavor specific configuration
variable WMS_FLAVOR_INCLUDE = if ( WMS_FLAVOR == 'glite' ) {
                                return('common/condor/wms');
                              } else {
                                return('common/condor/rb');
                              };
include { WMS_FLAVOR_INCLUDE };
