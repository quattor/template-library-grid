unique template features/grid/env;

variable GLITE_ARCH_LIB ?= if ( PKG_ARCH_GLITE == 'x86_64' ) {
                             '/lib64';
                           } else {
                             '/lib';
                           };

variable DEFAULT_DPM_HOST ?= if ( is_defined(DPM_HOST) ) {
                               DPM_HOST;
                             } else {
                               undef;
                             };

include { 'features/grid/base' };


# ----------------------------------------------------------------------------
# profile
# ----------------------------------------------------------------------------
include { 'components/profile/config' };

# Register gLite location in /system/glite
'/system/glite/config/GLITE_LOCATION' = GLITE_LOCATION;
'/system/glite/config/GLITE_LOCATION_VAR' = GLITE_LOCATION_VAR;
'/system/glite/config/GLITE_LOCATION_LOG' = GLITE_LOCATION_LOG;
'/system/glite/config/GLITE_TMP' = GLITE_LOCATION_TMP;

# Define proxy name used by GLITE_USER (must be the same for all services on 1 machine)
'/system/glite/config/GLITE_X509_PROXY' = GLITE_LOCATION_VAR + '/glite.proxy';

# Environmental variables.  Software locations.
'/software/components/profile/env/GLITE_LOCATION' = GLITE_LOCATION;
'/software/components/profile/env/GLITE_LOCATION_VAR' = GLITE_LOCATION_VAR;
'/software/components/profile/env/GLITE_LOCATION_LOG' = GLITE_LOCATION_LOG;
'/software/components/profile/env/GLITE_LOCATION_TMP' = GLITE_LOCATION_TMP;

# Force old mode for proxy renewal
# To be changed when new mode is supported by gLite
'/software/components/profile/env/GT_PROXY_MODE' = 'old';

# Path-like variables.
'/software/components/profile/path/PATH/prepend' = push(GLITE_LOCATION+'/bin', GLITE_LOCATION+'/externals/bin');
# For LD_LIBRARY_PATH on 64-bit both lib64 and lib are needed for 32-bit
# apps to work
#c-ares now in a standard path : removed.
'/software/components/profile/path/LD_LIBRARY_PATH/prepend' = push(GLITE_LOCATION+GLITE_ARCH_LIB+'/classads',GLITE_LOCATION+GLITE_ARCH_LIB,GLITE_LOCATION+'/lib');
'/software/components/profile/path/PYTHONPATH/prepend' = push(GLITE_LOCATION+GLITE_ARCH_LIB+'/python');
'/software/components/profile/path/PERLLIB/prepend' = push(GLITE_LOCATION+GLITE_ARCH_LIB+'/perl');
'/software/components/profile/path/MANPATH/append' = push(GLITE_LOCATION+'/share/man');

# Information System Location
'/software/components/profile/env/LCG_GFAL_INFOSYS' ?=
  if(is_defined(TOP_BDII_LIST))
    TOP_BDII_LIST
  else
    TOP_BDII_HOST+':'+to_string(BDII_PORT);

# The default myproxy server.
"/software/components/profile/env/MYPROXY_SERVER" = MYPROXY_DEFAULT_SERVER;

"/software/components/profile/env/SITE_NAME" = SITE_NAME;

# Setup variables for d-cache client.
# Should not be defined anymore, causing a warning when defined.
#"/software/components/profile/env/SRM_PATH" = DCACHE_LOCATION+"/srm";

# Locations of "optional" machine types.
"/software/components/profile/env" = {
  if (exists(GSSKLOG_SERVER)) {
    SELF["GSSKLOG_SERVER"] = GSSKLOG_SERVER;
  };
  if ( is_defined(DEFAULT_DPM_HOST) ) {
    SELF["DPM_HOST"] = DEFAULT_DPM_HOST;
    SELF["DPNS_HOST"] = DEFAULT_DPM_HOST;
  };
  SELF;
};

# Export location of CA certificates
"/software/components/profile/env/X509_CERT_DIR" = SITE_DEF_CERTDIR;

# Add empty entry to ensure that standard manpath is searched
# too (this is the effect of :: in MANPATH)
"/software/components/profile/path/MANPATH/prepend"= push("");
