unique template glite/wn/rpms/config;

# Variable to control installation of SL4 32-bit compatibility
variable WN_WLCG_SL4_32BIT_COMPAT ?= true;

# Additional RPMs from OS
# If you don't want them, define to null.
variable WN_ADDITIONAL_OS_PKGS ?= if ( is_null(SELF) ) {
                                    debug('Include of WN additional RPMs from OS disabled');
                                    SELF;
                                  } else {
                                    'config/emi/'+EMI_VERSION+'/wn';
                                  };


# WN-specific RPMS
include  { 'glite/wn/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/config' };


# OS-provided RPMs specific to WN.
# For backward compatibility, include only if it exists but don't forget
# to create it for the OS version you support if you want them !
variable WN_ADDITIONAL_OS_PKGS = if ( !is_null(SELF) && !is_defined(if_exists(SELF)) ) {
                                   debug('Template for WN additional RPMs from OS not found');
                                   undef;
                                 } else {
                                   SELF;
                                 };
include { WN_ADDITIONAL_OS_PKGS };

include { if ( WN_WLCG_SL4_32BIT_COMPAT ) 'glite/wn/rpms/'+OS_VERSION_PARAMS['major']+'/'+PKG_ARCH_GLITE+'/sl4_compat' };
