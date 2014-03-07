template update/23/config;

# EMI Update 23 (03.03.2014) - v2.10.7-1

variable update_postfix ?= '_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

include { 'update/23/rpms_base' + update_postfix };
include { 'update/23/rpms_thirdparty' + update_postfix };
include { 'update/23/rpms_updates' + update_postfix };
include { 'update/23/rpms_epel' + update_postfix + '-fix' };
