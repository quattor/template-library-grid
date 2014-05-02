# Configure LB environment variables and add them to the appropriate script

unique template feature/lb/env;

variable LB_PROFILE_SCRIPT ?= GLITE_LOCATION + '/etc/lb.conf';

# Use same variable names and default values for WMS and LB to ensure consistency if both 
# run on the same machine, whichever is included first.
variable WMS_CERT_DIR ?= GLITE_USER_HOME + "/.certs" ;
variable WMS_HOST_KEY ?= WMS_CERT_DIR + "/" + "hostkey.pem";
variable WMS_HOST_CERT ?= WMS_CERT_DIR + "/" + "hostcert.pem";


include { 'components/profile/config' };
include { 'components/wmslb/config' };

'/software/components/wmslb/env/GLITE_LOCATION' = GLITE_LOCATION;
'/software/components/wmslb/env/GLITE_LOCATION_LOG' = GLITE_LOCATION_LOG;
'/software/components/wmslb/env/GLITE_LOCATION_VAR' = GLITE_LOCATION_VAR;
'/software/components/wmslb/env/GLITE_LOCATION_TMP' = GLITE_LOCATION_TMP;
'/software/components/wmslb/env/GLITE_HOST_KEY' = '`dirname '+WMS_HOST_KEY+'`/`basename '+WMS_HOST_KEY+'`';
'/software/components/wmslb/env/GLITE_HOST_CERT' = '`dirname '+WMS_HOST_CERT+'`/`basename '+WMS_HOST_CERT+'`';
'/software/components/wmslb/env/GLITE_USER' = GLITE_USER;

'/software/components/profile' = component_profile_add_env(LB_PROFILE_SCRIPT, value('/software/components/wmslb/env'));
'/software/components/profile/scripts' = {
  SELF[escape(LB_PROFILE_SCRIPT)]['flavors'] = list('sh');
  SELF[escape(LB_PROFILE_SCRIPT)]['flavorSuffix'] = false;
  SELF;
};

