unique template personality/ui/config;

variable X509_USER_PROXY_PATH ?= "/tmp/x509up_u$(id -u)";

#-----------------------------------------------------------------------------
# Define need variable for glite-wms-command
#-----------------------------------------------------------------------------
'/software/components/profile' = component_profile_add_env(GLITE_GRID_ENV_PROFILE, nlist('X509_USER_PROXY',X509_USER_PROXY_PATH));

