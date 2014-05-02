unique template features/glexec/wn/service;

# Add RPMs
include { 'features/glexec/wn/rpms/config' };

# Modify the loadable library path.
include { 'features/ldconf/config' };

# Configuration for LCMAPS.
include { 'features/lcmaps/base' };

# Configuration for LCAS.
include { 'features/lcas/base' };

# Configure glexec WN
include { 'features/glexec/wn/config' };
