unique template glite/xrootd/rpms/config;

# RPMS common to all DPM node types
include  { 'glite/xrootd/rpms/' + PKG_ARCH_GLITE + '/server' };

# RPMS provided by OS
include { if_exists(OS_NS_CONFIG_EMI + 'xrootd') };
