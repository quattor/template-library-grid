unique template feature/glexec/wn/service;

# Add RPMs
include { 'feature/glexec/wn/rpms/config' };

# Modify the loadable library path.
include { 'feature/ldconf/config' };

# Configuration for LCMAPS.
include { 'feature/lcmaps/base' };

# Configuration for LCAS.
include { 'feature/lcas/base' };

# Configure glexec WN
include { 'feature/glexec/wn/config' };
