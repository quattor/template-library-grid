unique template personality/se_dpm/rpms/disk;

'/software/packages/{emi-dpm_disk}' ?= nlist();

include { if (XROOT_ENABLED) 'personality/se_dpm/rpms/xrootd' };
include { if (DPM_DAV_ENABLED) 'personality/se_dpm/rpms/dav' };
