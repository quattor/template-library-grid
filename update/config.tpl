# Template acting as an entry point to configure gLite updates

template update/config;

# Ensure EMI_UPDATE_VERSION is not undefined for later comparisons
variable EMI_UPDATE_VERSION ?= '';

variable EMI_UPDATE_POSTCONFIG ?= undef;


# Offical gLite update

variable EMI_UPDATE_INCLUDE = if ( is_defined(EMI_UPDATE_VERSION) && (length(EMI_UPDATE_VERSION) > 0) ) {
                                  'update/'+EMI_UPDATE_VERSION+'/config';
                                } else {
                                  undef;
                                };
include { EMI_UPDATE_INCLUDE };


# Update postconfig specific to a node type, if any : allow to install specific RPM versions for example.
# This requires both EMI_UPDATE_POSTCONFIG variable to be defined and 
# the template to exist in the current update.

variable EMI_UPDATE_POSTCONFIG_INCLUDE = if ( is_defined(EMI_UPDATE_INCLUDE) &&
                                                is_defined(EMI_UPDATE_POSTCONFIG) ) {
                                             if_exists('update/'+EMI_UPDATE_VERSION+'/'+EMI_UPDATE_POSTCONFIG);
                                           } else {
                                             undef;
                                           };
include { EMI_UPDATE_POSTCONFIG_INCLUDE };


# Other updates (services not part of gLite, ...)

include { if (is_defined(EMI_UPDATE_UNOFFICIAL) && EMI_UPDATE_UNOFFICIAL) 'update/unofficial/config' };
