unique template common/glexec/wn/service;

# Add RPMs
include { 'common/glexec/wn/rpms/config' + RPMS_SUFFIX };

# Modify the loadable library path.
include { 'common/ldconf/config' };

# Configuration for LCMAPS.
include { 'common/lcmaps/base' };

# Configuration for LCAS.
include { 'common/lcas/base' };

# Configure glexec WN
include { 'common/glexec/wn/config' };

