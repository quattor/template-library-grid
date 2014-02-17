unique template glite/se_dpm/rpms/head-yd;

'/software/packages/{emi-dpm_mysql}' ?= nlist();
'/software/packages/{argus-pep-api-c}' ?= nlist();
'/software/packages/{dpm-contrib-admintools}' ?= nlist();

include { if (XROOT_ENABLED) 'glite/se_dpm/rpms/xrootd-yd' };
include { if (SEDPM_MONITORING_ENABLED) 'glite/se_dpm/rpms/monitoring-yd' };
include { if (DPM_DAV_ENABLED) 'glite/se_dpm/rpms/dav-yd' };
