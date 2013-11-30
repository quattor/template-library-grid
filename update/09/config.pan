template update/09/config;

variable update_postfix ?= '_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

include { 'update/09/rpms_base' + update_postfix };
include { 'update/09/rpms_thirdparty' + update_postfix };
include { 'update/09/rpms_updates' + update_postfix };
include { 'update/09/rpms_epel' + update_postfix + '-fix' };
