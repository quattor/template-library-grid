template update/12/config;

variable update_postfix ?= '_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

include { 'update/12/rpms_epel' + update_postfix + '-fix' };
include { 'update/12/rpms_base' + update_postfix };
include { 'update/12/rpms_thirdparty' + update_postfix };
include { 'update/12/rpms_updates' + update_postfix };
