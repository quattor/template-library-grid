############################################################
#
# template machine-types/grid/ui
#
# RESPONSIBLE: Charles Loomis
#
############################################################

template machine-types/grid/ui;

variable UI_CONFIG_SITE ?= null;
# Additional site parameters included only when GSISSH_SERVER_ENABLED is true.
# It is included BEFORE the UI service configuration.
variable UI_GSISSH_CONFIG_SITE ?= null;
variable GSISSH_SERVER_ENABLED ?= false;

#
# Virtual organization configuration options.
# Must be done before calling machine-types/grid/base.
# If gsissh access to the UI is enabled, accounts will be automatically
# created for the VOs authorized to use gsissh access.
#
variable CONFIGURE_VOS = true;
variable NODE_VO_ACCOUNTS = GSISSH_SERVER_ENABLED;
variable NODE_VO_PROFILE_ENV = true;
variable NODE_VO_GRIDMAPDIR_CONFIG = GSISSH_SERVER_ENABLED;
# If an account is created for gsissh support, home directory must be created too
# (considered local to UI by default, set to undef or false if this is not the case).
# Also if VO accounts are created, they must have a shell allowing interactive login.
# Use bash by default
variable CREATE_HOME = true;
variable VO_ACCOUNT_SHELL ?= '/bin/bash';

variable VOMSES_DIR ?= '/etc/vomses';
#
# Make sure CE_TORQUE is false, so that torque based
# MPI rpms don't get installed.
#
variable ENABLE_MPI ?= false;

#
# Include base configuration of a gLite node
#
include 'machine-types/grid/base';


# Include UI GSISSH site parameters if GSISSH is configured
variable UI_GSISSH_SITE_INCLUDE = if ( GSISSH_SERVER_ENABLED ) {
    UI_GSISSH_CONFIG_SITE;
} else {
    null;
};
include UI_GSISSH_SITE_INCLUDE;


# UI configuration
#
variable UI_INCLUDE = if ( GSISSH_SERVER_ENABLED ) {
    'personality/ui_gsissh/service';
} else {
    'personality/ui/service';
};
include UI_INCLUDE;

#
# Add local users, if any
#
variable UI_USERS_INCLUDE = if (  GSISSH_SERVER_ENABLED ) {
    null;
} else {
    if_exists('site/config/local_users');
};
include UI_USERS_INCLUDE;

#
# Add site specific configuration, if any
include UI_CONFIG_SITE;


#
# middleware updates
#
include if_exists('update/config');


# Do any final configuration needed for some reasons (e.g. : run gLite 3.0 on SL4)
# Should be done at the very end of machine configuration
#
include if_exists(GLITE_OS_POSTCONFIG);
