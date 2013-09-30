unique template glite/ui/rpms/config;

# Variable to control installation of SL4 32-bit compatibility
variable UI_WLCG_SL4_32BIT_COMPAT ?= true;

# Additional RPMs from OS (common with WN)
# If you don't want them, define to null.
variable UI_ADDITIONAL_OS_PKGS ?= if ( is_null(SELF) ) {
                                    debug('Include of WN additional RPMs from OS disabled');
                                    SELF;
                                  } else {
                                    'config/glite/'+EMI_VERSION+'/wn';
                                  };


# UI-specific RPMS
include  { 'glite/ui/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE +  '/config' };


# OS-provided RPMs specific to WN (also added on UI for environment # compatibility).
# For backward compatibility, include only if it exists but don't forget
# to create it for the OS version you support if you want them !
variable UI_ADDITIONAL_OS_PKGS = if ( !is_null(SELF) && !is_defined(if_exists(SELF)) ) {
                                   debug('Template for WN additional RPMs from OS not found');
                                   undef;
                                 } else {
                                   SELF;
                                 };
include { UI_ADDITIONAL_OS_PKGS };




