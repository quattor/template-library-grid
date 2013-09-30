unique template glite/wms/rpms/config;

# RPMS for LB
include  { 'glite/wms/rpms/' + PKG_ARCH_GLITE + '/config' };

# Add OS RPMs specific to WMS
variable OS_WMS_SPECIFIC_RPMS ?= if_exists('config/glite/'+EMI_VERSION+'/wms');
include { OS_WMS_SPECIFIC_RPMS };


