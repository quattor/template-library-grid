# This template defines gLite major version and default update.
# Included very early in the configuration.
  
unique template defaults/glite/version;

# Default gLite update to install. Set to '' to install no update.
# Can be overriden in a machine profile or at cluster or site level
variable EMI_UPDATE_VERSION ?= '05';
variable HEP_OSlibs_VERSION ?= '1.0.3-0';

# gLite major version (used mainly to tune OS configuration).
# There is no reason to redefine this variable.
variable EMI_VERSION = '3.0';
