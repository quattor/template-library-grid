unique template glite/bdii/rpms/config;

# BDII RPMs
include  { 'glite/bdii/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

# Additional RPMs from OS, if you don't want them, define to 'null'.
variable BDII_ADDITIONAL_OS_PKGS ?= 'config/emi/' + EMI_VERSION + '/bdii';
include { if_exists(BDII_ADDITIONAL_OS_PKGS) };
