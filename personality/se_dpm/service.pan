unique template personality/se_dpm/service;

# SEDPM_CONFIG_SITE is the legacy name of the variable.
variable SEDPM_CONFIG_SITE ?= null;
variable DPM_CONFIG_SITE ?= SEDPM_CONFIG_SITE;
variable DPM_USE_PUPPET_CONFIG ?= false;

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Modify the loadable library path. 
include { 'features/ldconf/config' };

# EDG, LCG, and Globus sysconfig files and environment variables
include { 'features/globus/sysconfig' };
include { 'features/grid/env' };


# Add accepted CAs certificates
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };


# Authorization via grid mapfile. 
include { 'features/mkgridmap/standard' };
include { 'features/mkgridmap/lcgdm' };

include {
	if(DPM_USE_PUPPET_CONFIG){
		'personality/se_dpm/service_puppet';
	}else{
		'personality/se_dpm/service_quattor';
	};
};

