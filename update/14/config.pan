template update/14/config;

# EMI-3 Update 14 (03.03.2014) - v3.7.2-1

variable update_postfix ?= '_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

include { 'update/14/rpms_base' + update_postfix };
include { 'update/14/rpms_thirdparty' + update_postfix };
include { 'update/14/rpms_updates' + update_postfix };
include { 'update/14/rpms_epel' + update_postfix + '-fix' };
