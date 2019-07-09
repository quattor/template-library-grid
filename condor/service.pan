template features/arc-ce/condor/service;

include 'components/chkconfig/config';
include 'components/dirperm/config';
include 'components/filecopy/config';
include 'components/sysctl/config';


# Default version
variable CONDOR_VERSION ?= '8.6.4-1.el6';
variable CONDOR_ARCH ?= 'x86_64';

'/software/repositories' = append(create('repository/htcondor/el6-x86_64'));

# Condor
'/software/packages' = {
    pkg_repl('condor', CONDOR_VERSION, CONDOR_ARCH);
    pkg_repl('condor-python', CONDOR_VERSION, CONDOR_ARCH);
    pkg_repl('condor-classads', CONDOR_VERSION, CONDOR_ARCH);
    pkg_repl('condor-external-libs', CONDOR_VERSION, CONDOR_ARCH);
    pkg_repl('condor-procd', CONDOR_VERSION, CONDOR_ARCH);
};

## Configure as schedd
include 'features/arc-ce/condor/schedd';

# Increase the ephemeral port range
'/software/components/sysctl/variables/net.ipv4.ip_local_port_range' = '30000 65535';

# Directory for storing all condor history files
# really needed? - only for condor-history-to-mysql
'/software/components/dirperm/paths' = append(SELF, dict(
    'path', '/var/local/condor-history',
    'owner', 'root:root',
    'perm', '0755',
    'type', 'd'
));

# Make sure the appropriate services are running
'/software/components/chkconfig/service/condor' = dict(
    'on', '',
    'startstop', true,
);
