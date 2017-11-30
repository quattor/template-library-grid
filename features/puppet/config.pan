template features/puppet/config;

include 'components/puppet/config';
include 'components/spma/config';

'/software/packages/{puppet}' ?= dict();

include 'features/puppet/defaults';



