# This template defines Condor config for use by the EMI WMS

unique template features/condor/config;

variable CONDOR_VERSION ?= null;
variable CONDOR_USER ?= GLITE_USER;
variable CONDOR_GROUP ?= GLITE_GROUP;


# Define Condor related paths
variable CONDOR_VAR_DIR ?= "/var/condor";
variable CONDOR_CONFIG_FILE ?= '/etc/condor/condor_config';
variable CONDOR_LOCAL_CONFIG_FILE ?= '/var/condor/condor_config.local';
variable CONDOR_INSTALL_PATH ?= '/usr';
variable CONDOR_ADMIN ?= SITE_EMAIL;

variable CONDOR_CONFIG_CONTENTS = file_contents('features/condor/templ/condor_config.templ');
variable CONDOR_CONFIG_CONTENTS = replace('\$\(TILDE\)',CONDOR_VAR_DIR,CONDOR_CONFIG_CONTENTS);

variable CONDOR_LOCAL_CONFIG_CONTENTS = file_contents('features/condor/templ/condor_config.local.templ');
variable CONDOR_LOCAL_CONFIG_CONTENTS = replace('<%HOSTNAME%>',FULL_HOSTNAME,CONDOR_LOCAL_CONFIG_CONTENTS);
variable CONDOR_LOCAL_CONFIG_CONTENTS = replace('<%CONDOR_ADMIN%>',CONDOR_ADMIN,CONDOR_LOCAL_CONFIG_CONTENTS);
variable CONDOR_LOCAL_CONFIG_CONTENTS = replace('<%PORT_MIN%>',GLOBUS_TCP_PORT_RANGE_MIN,CONDOR_LOCAL_CONFIG_CONTENTS);
variable CONDOR_LOCAL_CONFIG_CONTENTS = replace('<%PORT_MAX%>',GLOBUS_TCP_PORT_RANGE_MAX,CONDOR_LOCAL_CONFIG_CONTENTS);

include { 'components/filecopy/config' };
'/software/components/filecopy/dependencies/post' = append('glitestartup');
'/software/components/glitestartup/dependencies/pre' = append('filecopy');

'/software/components/filecopy/services' =
  npush(escape(CONDOR_LOCAL_CONFIG_FILE),
        nlist("config", CONDOR_LOCAL_CONFIG_CONTENTS,
              "owner", "root",
              "perms", "0644",
        )
  );

'/software/components/filecopy/services' =
  npush(escape(CONDOR_CONFIG_FILE),
        nlist("config", CONDOR_CONFIG_CONTENTS,
              "owner", "root",
              "perms", "0644",
        )
  );


# ----------------------------------------------------------------------------
# dirperm
# ----------------------------------------------------------------------------
include { 'components/dirperm/config' };

# Add ncm-accounts as a pre dependency for ncm-dirperm
"/software/components/dirperm/dependencies/pre" = {
  if ( !exists(SELF) ||
       !is_defined(SELF) ||
       !is_list(SELF) ) {
    return(list('accounts'));
  } else {
    found = false;
    dependencies = SELF;
    ok = first(dependencies, i, v);
    while (ok) {
      if ( v == 'accounts' ) {
        found = true;
      };
      ok = next(dependencies, i, v);
    };
    if ( ! found ) {
      dependencies[length(dependencies)] = 'accounts';
    };
    return(dependencies);
  };

};

# Set permissions for Condor specific directories
variable CONDOR_DIRECTORIES = list(
  CONDOR_VAR_DIR + '/config',
  CONDOR_VAR_DIR + '/lib',
  CONDOR_VAR_DIR + '/lib/condor',
  CONDOR_VAR_DIR + '/lib/condor/spool',
  CONDOR_VAR_DIR + '/lock',
  CONDOR_VAR_DIR + '/lock/condor',
  CONDOR_VAR_DIR + '/log',
  CONDOR_VAR_DIR + '/log/condor',
  CONDOR_VAR_DIR + '/run',
  CONDOR_VAR_DIR + '/run/condor',
  CONDOR_VAR_DIR + '/spool',
);

'/software/components/dirperm/paths' = {
  foreach(k;directory;CONDOR_DIRECTORIES) {
    SELF[length(SELF)] = nlist(
      'path', directory,
      'owner' , CONDOR_USER+':'+CONDOR_GROUP,
      'perm', '0755',
      'type', 'd',
    );
  };

  SELF[length(SELF)] = nlist('path', CONDOR_VAR_DIR + '/execute',
                             'owner', CONDOR_USER+':'+CONDOR_GROUP,
                             'perm', '1777',
                             'type', 'd');

  SELF;
};

# Include Condor Configuration
include { 'features/condor/wms' };
