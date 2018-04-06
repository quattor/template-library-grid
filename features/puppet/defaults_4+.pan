template features/puppet/defaults_4+;

include 'components/puppet/config';

prefix '/software/components/puppet';
'hieraconf_file' = '/etc/puppetlabs/code/environments/production/hiera.yaml';
'puppet_cmd' = '/opt/puppetlabs/bin/puppet';
'puppetconf_file' = '/etc/puppetlabs/puppet/puppet.conf';
