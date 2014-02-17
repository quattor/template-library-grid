unique template glite/se_dpm/rpms/disk-yd;

'/software/packages/{emi-dpm_disk}' ?= nlist();

include { if (XROOT_ENABLED) 'glite/se_dpm/rpms/xrootd-yd' };
include { if (DPM_DAV_ENABLED) 'glite/se_dpm/rpms/dav-yd' };
