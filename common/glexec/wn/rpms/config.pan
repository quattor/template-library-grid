unique template common/glexec/wn/rpms/config;

# RPMS for GLEXEC_wn
include { 'common/glexec/wn/rpms/' + PKG_ARCH_GLITE + '/config' };

# Add OS RPMs specific to GLEXEC_wn 
include { if_exists('config/emi/'+EMI_VERSION+'/glexec-wn') };

