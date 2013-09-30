# This template configure gLite WMS clients
unique template common/wms/client;

# Default is not to define output storage
variable WMS_OUTPUT_STORAGE_DEFAULT ?= null;

# ---------------------------------------------------------------------------- 
# wmsclient
# ---------------------------------------------------------------------------- 
include { 'components/wmsclient/config' };
'/software/components/wmsclient/glite/active' = false;
'/software/components/wmsclient/wmproxy/active' = true;
'/software/components/wmsclient/wmproxy/configDir' = '/etc/glite-wms';
'/software/components/wmsclient/wmproxy/defaultAttrs/outputStorage' = WMS_OUTPUT_STORAGE_DEFAULT;
'/software/components/wmsclient/register_change' = push('/system/glite/config/GLITE_LOCATION');

