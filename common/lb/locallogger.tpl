
unique template common/lb/locallogger;

variable LOCALLOGGER_SERVICE ?= 'glite-lb-locallogger';


# Define environment variables required by LB
include { 'common/lb/env' };

# Add gLite user
include { 'users/glite' };

# Do a copy of machine cert/key for locallogger usage
'/software/components/filecopy/services' = {
  SELF[escape(WMS_HOST_KEY)] = nlist('source', SITE_DEF_HOST_KEY,
                                       'owner', GLITE_USER+':'+GLITE_GROUP,
                                       'perms', '0400',
                                       );
  SELF[escape(WMS_HOST_CERT)] = nlist('source', SITE_DEF_HOST_CERT,
                                        'owner', GLITE_USER+':'+GLITE_GROUP,
                                        'perms', '0644',
                                        );
  SELF;
};


# Configure glitestartup as a post-dependency for filecopy
include { 'components/filecopy/config' };
'/software/components/filecopy/dependencies/post' = push('glitestartup');

# Add locallogger service to the list of gLite enabled services
include { 'components/glitestartup/config' };

'/software/components/glitestartup/restartServices' = true;
'/software/components/glitestartup/createProxy' = true;
'/software/components/glitestartup/services' = glitestartup_mod_service(LOCALLOGGER_SERVICE);

