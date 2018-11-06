unique template personality/se_dpm/puppet/release_modules;

include 'components/spma/config';

'/software/packages/' = pkg_repl('dmlite-puppet-dpm');

include 'components/puppet/config';

prefix '/software/components/puppet';

'modulepath' ?= '';

'modulepath' = value('/software/components/puppet/modulepath') + ':/usr/share/dmlite/puppet/modules';
