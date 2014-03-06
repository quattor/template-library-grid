
unique template feature/maui/client/service;

# Add RPMs
include { 'feature/maui/client/rpms/config' };

# Configure maui client
include { 'feature/maui/client/config' };

# Update base RPMS if necessary
#include { 'feature/maui/update/rpms' };
