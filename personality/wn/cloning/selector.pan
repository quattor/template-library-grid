# This template is responsible for deciding if a node profile must be
# rebuilt or cloned. Profile cloning allows a very significant compilation
# speed-up for nodes sharing the same configuration apart from hardware
# differences.
#
# Note that cloning relies on a Pan feature that guarantees the
# reference profile included in another profile will be compiled first
# if it is not up-to-date.

unique template personality/wn/cloning/selector;

# Disable profile cloning by default.
# For backward compatibility, use USE_DUMMY if defined and if
# PROFILE_CLONING_ENABLED is not defined. 
variable USE_DUMMY ?= false;
variable PROFILE_CLONING_ENABLED ?= USE_DUMMY;

# PROFILE_PREFIX defines the file name prefix that must be removed from
# the profile template to find the node name.
# For example when using the legacy naming for profile templates, the
# following can be used:
#       variable PROFILE_PREFIX ?= 'profile_';
variable PROFILE_PREFIX ?= '';

# Backward compatibility with legacy variable names
variable EXACT_NODE ?= undef;
variable PROFILE_CLONING_REFERENCE_NODE ?= EXACT_NODE;
variable NODE_REGEXP ?= '%%%invalid%%%node%%%';
variable PROFILE_CLONING_ELIGIBLE_NODES ?= NODE_REGEXP;

# Check PROFILE_CLONING_DISABLED to see if profile cloning must be disabled on
# the current node, despite PROFILE_CLONING_ENABLED=true.
# PROFILE_CLONING_DISABLED is a nlist where the key is the string (escaped) after
# PROFILE_PREFIX in the profile name (note that host name cannot be used
# at this early stage).
# For backward compatibility, if PROFILE_CLONING_DISABLED is not
# defined, check if WN_DUMMY_DSIABLED is defined.
variable WN_DUMMY_DISABLED ?= nlist();
variable PROFILE_CLONING_DISABLED ?= WN_DUMMY_DISABLED;
variable PROFILE_CLONING_CURRENT_NODE = {
  if ( length(PROFILE_PREFIX) > 0 ) {
    node = replace(PROFILE_PREFIX,'',OBJECT);
  } else {
    node = OBJECT;
  };
  node;
};
variable PROFILE_CLONING_ENABLED = {
  if ( is_defined(SELF) && SELF ) {
    if ( is_defined(PROFILE_CLONING_DISABLED[escape(PROFILE_CLONING_CURRENT_NODE)]) && PROFILE_CLONING_DISABLED[escape(PROFILE_CLONING_CURRENT_NODE)] ) {
      debug('Profile cloning disabled for node '+PROFILE_CLONING_CURRENT_NODE);
      false;
    } else {
      true;
    };
  } else {
    debug('Profile cloning not enabled');
    false;
  };
};


# Check if the current node must be cloned from a reference node.
# For the cloning to happen, the following conditions must be met:
#   - PROFILE_CLONING_ENABLED must be true
#   - Reference node must be defined and must exist in the same cluster
#   - The current node must match the regexp in PROFILE_CLONING_ELIGIBLE
#   - The machine must not be the reference node
#   - The current node must match the regexp in PROFILE_CLONING_ELIGIBLE

variable PROFILE_CLONING_CLONED_NODE ?= {
  if ( PROFILE_CLONING_ENABLED ) {
    if ( !is_string(PROFILE_CLONING_REFERENCE_NODE) || (length(PROFILE_CLONING_REFERENCE_NODE) == 0) ) {
      debug('Reference node not defined. Cloning disabled');
      false;
    } else if (match(PROFILE_CLONING_CURRENT_NODE,PROFILE_CLONING_ELIGIBLE_NODES)) {
      if ( PROFILE_CLONING_CURRENT_NODE == PROFILE_CLONING_REFERENCE_NODE ) {
        debug(PROFILE_CLONING_CURRENT_NODE+' is the reference node. Cloning disabled.');
        false;
      } else {
        reference_profile = PROFILE_PREFIX + PROFILE_CLONING_REFERENCE_NODE;
        if ( is_defined(if_exists(reference_profile)) ) { 
          debug('Cloning '+OBJECT+' from '+reference_profile);
          true;
        } else {
          debug(PROFILE_CLONING_CURRENT_NODE+' eligible to cloning but reference node profile ('+reference_profile+'.tpl) not found. Cloning disabled');
          false;
        };
      };  
    } else {
      debug(PROFILE_CLONING_CURRENT_NODE+' not eligible to profile cloning (regexp='+PROFILE_CLONING_ELIGIBLE_NODES+')');
      false;
    };
  } else {
    false;
  };  
};


# Name of an optional template to execute at the end of the cloning.
# Default: none
variable PROFILE_CLONING_CLONED_NODE_POSTCONFIG ?= null;
variable PROFILE_CLONING_CLONED_NODE_POSTCONFIG = {
  if (PROFILE_CLONING_CLONED_NODE) {
    PROFILE_CLONING_CLONED_NODE_POSTCONFIG;
  } else {
    null;
  };
};


