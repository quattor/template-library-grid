# Configuration specific to gLite WN

unique template glite/wn/config;

# When not using home directories, configure cleanup of home directories
variable CE_CLEANUP_ACCOUNTS_LOCAL_ONLY ?= true;
variable CE_CLEANUP_ACCOUNTS_USE_GRIDMAPDIR ?= false;
include { if ( ! CE_SHARED_HOMES ) 'lcg/ce/cleanup-accounts' };
