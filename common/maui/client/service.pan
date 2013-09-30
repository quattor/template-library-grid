
unique template common/maui/client/service;

# Add RPMs
include { 'common/maui/client/rpms/config' };

# Configure maui client
include { 'common/maui/client/config' };

# Update base RPMS if necessary
#include { 'common/maui/update/rpms' };
