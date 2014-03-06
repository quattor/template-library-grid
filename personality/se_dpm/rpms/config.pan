unique template personality/se_dpm/rpms/config;

# RPMS specific to this node type
# (be sure to define variables according to service node type to register the
# proper information into Information System)
variable SEDPM_MACHINE_RPMS = {
    if ( SEDPM_IS_HEAD_NODE ) {
        'personality/se_dpm/rpms/head';
    } else {
        'personality/se_dpm/rpms/disk';
    };
};
include { SEDPM_MACHINE_RPMS };
