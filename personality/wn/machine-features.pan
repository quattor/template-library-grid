template personality/wn/machine-features;

variable MACHINE_FEATURES_PATH ?= '/etc/machinefeatures';
variable WN_HS06 ?= nlist();
variable WN_SHUTDOWNTIME ?= nlist();

include { 'components/dirperm/config' };

'/software/components/dirperm/paths' = push(
  nlist('path',MACHINE_FEATURES_PATH,
        'owner','root:root',
        'perm','0755',
        'type','d')
);


#------------------------------------------------------------------------------
# Configure the HS06 rating for a single core
#------------------------------------------------------------------------------

variable WN_HS06_FILE ?= MACHINE_FEATURES_PATH + '/hs06';
variable WN_HS06_CONTENTS ?= {
  if ( is_defined(WN_HS06[FULL_HOSTNAME]) ) {
    contents = to_string(WN_HS06[FULL_HOSTNAME]) + "\n";
  } else {
    contents = "\n";
  };

  contents;
};

"/software/components/filecopy/services" = npush(
  escape(WN_HS06_FILE), nlist(
    "config",WN_HS06_CONTENTS,
    "owner","root",
    "perms","0644",
  )
);


#------------------------------------------------------------------------------
# Configure the timestamp for when the node is expected to be rebooted
#------------------------------------------------------------------------------

variable WN_SHUTDOWN_FILE ?= MACHINE_FEATURES_PATH + '/shutdowntime';
variable SHUTDOWNTIME_CONTENTS ?= {
  if ( is_defined(WN_SHUTDOWNTIME[FULL_HOSTNAME]) ) {
    contents = to_string(WN_SHUTDOWNTIME[FULL_HOSTNAME]) + "\n";
  } else {
    contents = "\n";
  };

  contents;
};

"/software/components/filecopy/services" = npush(
  escape(WN_SHUTDOWN_FILE), nlist(
    "config",SHUTDOWNTIME_CONTENTS,
    "owner","root",
    "perms","0644",
  )
);
