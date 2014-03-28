unique template personality/se_dpm/rpms/head;

'/software/packages/{emi-dpm_mysql}' ?= nlist();
'/software/packages/{argus-pep-api-c}' ?= nlist();
'/software/packages/{dpm-contrib-admintools}' ?= nlist();

include { if (XROOT_ENABLED) 'personality/se_dpm/rpms/xrootd' };
include { if (SEDPM_MONITORING_ENABLED) 'personality/se_dpm/rpms/monitoring' };
include { if (DPM_DAV_ENABLED) 'personality/se_dpm/rpms/dav' };

