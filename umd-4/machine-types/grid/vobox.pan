template machine-types/grid/vobox;

variable VOBOX_CONFIG_SITE ?= null;

# Ensure gsissh port is 1975, whatever is the site default defined later
variable GSISSH_PORT ?= 1975;


# Virtual organization configuration options.
# Must be done before calling machine-types/base
variable CONFIGURE_VOS ?= true;
variable NODE_VO_ACCOUNTS ?= true;
variable CREATE_HOME ?= undef;
variable NODE_VO_INFO_DIR ?= true;
variable NODE_VO_GRIDMAPDIR_CONFIG ?= true;
variable NODE_VO_PROFILE_ENV ?= true;
variable VO_GRIDMAPFILE_MAP_VOMS_ROLES ?= true;
variable GSISSH_SERVER_ENABLED ?= true;
# Means that X509_USER_PROXY variable will not be defined.
# Define to something or to undef if you want this variable to be defined.
# undef will result in using the default value.
variable X509_USER_PROXY_PATH ?= null;


# Include base configuration of a gLite node.
# A specific template is executed a the very begining of the VO configuration to
# ensure that only one VO is configured for access to VOBOX services.
variable NODE_VO_CONFIG = 'personality/vobox/init';
include 'machine-types/grid/ui';


# VOBOX configuration
include 'personality/vobox/service';


# Add site specific configuration, if any
include VOBOX_CONFIG_SITE;


# gLite updates
include if_exists('update/config');


# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
include GLITE_OS_POSTCONFIG;


