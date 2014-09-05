# Template to configure a LB locallogger on a machine other than the LB for WMS

unique template features/lb/locallogger;

variable LOCALLOGGER_SERVICE ?= 'glite-lb-locallogger';


# Define environment variables required by LB
include { 'features/lb/env' };

# Add gLite user
include { 'users/glite' };


# Configure glite-lb-locallogger startup
include { 'features/lb/glitestartup' };
'/software/components/glitestartup/services' = glitestartup_mod_service(LOCALLOGGER_SERVICE);

# Ensure it is not enabled in chkconfig (it used to be in Quattor config).
# Can be removed in the future (4/9/2014)
include { 'components/chkconfig/config' };
prefix '/software/components/chkconfig';
'service' = {
  SELF[LOCALLOGGER_SERVICE] = nlist('off','');
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
