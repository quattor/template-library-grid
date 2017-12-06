template features/puppet/config;

include 'components/puppet/config';
include 'components/spma/config';

'/software/packages' = pkg_repl('puppet');

include 'features/puppet/defaults';


