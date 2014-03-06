
# Maui server configuration

unique template feature/maui/server/service;

include { 'feature/maui/server/rpms/config' };

include { 'feature/maui/server/config' };

# Update base RPMS if necessary
#include { 'feature/maui/update/rpms' };
