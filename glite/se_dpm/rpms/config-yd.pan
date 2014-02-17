unique template glite/se_dpm/rpms/config-yd;

# RPMS specific to this node type
# (be sure to define variables according to service node type to register the
# proper information into Information System)
variable SEDPM_MACHINE_RPMS = {
    if ( SEDPM_IS_HEAD_NODE ) {
        'glite/se_dpm/rpms/head-yd';
    } else {
        'glite/se_dpm/rpms/disk-yd';
    };
};
include { SEDPM_MACHINE_RPMS };
