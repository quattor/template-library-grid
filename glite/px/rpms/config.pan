unique template glite/px/rpms/config;

# MyProxy specific RPMs
include  { 'glite/px/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };

# Additional RPMs from OS, if you don't want them, define to 'null'.
variable PX_ADDITIONAL_OS_PKGS ?= 'config/emi/' + EMI_VERSION + '/px';
include { if_exists(PX_ADDITIONAL_OS_PKGS) };
