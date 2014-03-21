
unique template feature/lb/locallogger;

variable LOCALLOGGER_SERVICE ?= 'glite-lb-locallogger';


# Define environment variables required by LB
include { 'feature/lb/env' };

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

# Add glite-lb-locallogger to chkconfig

include { 'components/chkconfig/config' };

prefix '/software/components/chkconfig';

'service' = {
  SELF[LOCALLOGGER_SERVICE] = nlist('on','',
                                   'startstop',true);
  SELF;
};

# Fix /var/run/glite ownership

include { 'components/dirperm/config' };

prefix '/software/components/dirperm';

'paths' = append(
  nlist(
    'owner','glite:glite',
    'path', '/var/run/glite',
    'perm', '0755',
    'type', 'd',
  )
);
