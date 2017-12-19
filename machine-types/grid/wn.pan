# This is a wrapper template for a workernode
# to enable a build speedup using profile cloning, also
# known as 'clone speedup' or 'dummy WN'

template machine-types/grid/wn;

# Include site configuration for profile cloning.
# If it doesn't exist, profile cloning will not be used.
variable PROFILE_CLONING_CONFIG_SITE ?= 'site/wn-cloning-config';
variable  PROFILE_CLONING_CONFIG_INCLUDE ?= if_exists(PROFILE_CLONING_CONFIG_SITE);
variable PROFILE_CLONING_CONFIG_INCLUDE ?= debug('Profile cloning not configured');
include { PROFILE_CLONING_CONFIG_INCLUDE };


# Check if the node must be cloned.
# The selector must define PROFILE_CLONING_CLONED_NODE according to what
# must be done. Define it to false in case it is not defined by the selector.
variable PROFILE_CLONING_SELECTOR ?= 'personality/wn/cloning/selector';
include { PROFILE_CLONING_SELECTOR };
variable PROFILE_CLONING_CLONED_NODE ?= false;

include {
    if ( is_defined(PROFILE_CLONING_CLONED_NODE) && PROFILE_CLONING_CLONED_NODE ) {
        return('personality/wn/cloning/clone');
    } else {
        return('personality/wn/cloning/standard');
    };
};
