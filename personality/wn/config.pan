# Configuration specific to gLite WN

unique template personality/wn/config;

# When not using home directories, configure cleanup of home directories
variable CE_CLEANUP_ACCOUNTS_LOCAL_ONLY ?= true;
variable CE_CLEANUP_ACCOUNTS_USE_GRIDMAPDIR ?= false;
variable WN_MACHINE_FEATURES_ENABLED ?= false;

include { if ( ! CE_SHARED_HOMES ) 'personality/cream_ce/cleanup-accounts' };
include { if (WN_MACHINE_FEATURES_ENABLED) 'personality/wn/machine-features' };
