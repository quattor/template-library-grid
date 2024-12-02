unique template features/gip/ce-condor-plugins;

# info-dynamic-condor is the recommended plugin for HTCondor.
# A legacy plugin (lcg-info-dynamic-condor) used to exist:
# Redefine this variable if you want to use it.
variable GIP_CE_CONDOR_INFO_DYNAMIC_PLUGIN ?= 'info-dynamic-condor';

# Dependency required by Condor scripts
'/software/packages' = pkg_repl('python-argparse');


# Scripts
include {'components/filecopy/config'};
'/software/components/filecopy/services/' = {
  SELF[escape('/usr/libexec/'+GIP_CE_CONDOR_INFO_DYNAMIC_PLUGIN)]=dict(
    "config", file_contents('features/gip/files/'+GIP_CE_CONDOR_INFO_DYNAMIC_PLUGIN),
    "owner", "root",
    "perms","0755",
  );
  SELF[escape('/usr/libexec/lrmsinfo-condor')]=dict(
    "config", file_contents('features/gip/files/lrmsinfo-condor'),
    "owner", "root",
    "perms","0755",
  );

  SELF;
};


