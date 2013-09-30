unique template glite/ui_gsissh/rpms/config;

# RPMs specific to GSISSH UI
include  { 'glite/ui_gsissh/rpms/' + PKG_ARCH_GLITE + '/config' };

# OS RPMs required by GSISSH UI
include { 'config/emi/' + EMI_VERSION + '/ui-gsissh' };
