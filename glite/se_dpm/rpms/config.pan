unique template glite/se_dpm/rpms/config;

# RPMS common to all DPM node types
include  { 'glite/se_dpm/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_GLITE + '/base' };

# RPMS specific to this node type
# (be sure to define variables according to service node type to register the
# proper information into Information System)
variable SEDPM_MACHINE_RPMS = if ( SEDPM_IS_HEAD_NODE ) {
                                'glite/se_dpm/rpms/'+OS_VERSION_PARAMS['major'] + '/' +PKG_ARCH_GLITE+'/head';
                               } else {
                                 'glite/se_dpm/rpms/'+OS_VERSION_PARAMS['major'] + '/' +PKG_ARCH_GLITE+'/disk';
                               };
include { SEDPM_MACHINE_RPMS };
