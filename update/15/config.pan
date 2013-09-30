template update/15/config;

variable update_postfix ?= '_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

include { 'update/15/rpms_base' + update_postfix };
include { 'update/15/rpms_thirdparty' + update_postfix };
include { 'update/15/rpms_updates' + update_postfix };
include { 'update/15/rpms_epel' + update_postfix + '-fix' };
