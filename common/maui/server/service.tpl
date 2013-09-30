
# Maui server configuration

unique template common/maui/server/service;

include { 'common/maui/server/rpms/config' };

include { 'common/maui/server/config' };

# Update base RPMS if necessary
#include { 'common/maui/update/rpms' };
