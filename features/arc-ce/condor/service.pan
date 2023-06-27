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

'/software/components/filecopy/services/{/etc/condor/config.d/12resourcelimits.config}' = dict(
    'config', file_contents('features/arc-ce/condor/resourcelimits.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', '/usr/sbin/condor_reconfig -daemon schedd',
);

## Configure as schedd
include 'features/arc-ce/condor/schedd';

# Increase the ephemeral port range
'/software/components/sysctl/variables/net.ipv4.ip_local_port_range' = '30000 65535';

# Increase number of open files & processes
'/software/components/filecopy/services/{/etc/security/limits.d/91-condor.conf}' = dict(
    'config', file_contents('features/arc-ce/condor/limits.conf'),
    'owner', 'root:root',
    'perms', '0644',
);

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

include 'features/arc-ce/container-images';

variable HTCONDOR_DOCKER_IMAGES ?= dict();

'/software/components/filecopy/services/{/etc/condor/config.d/67job-transform-docker.config}' = dict(
    'config', substitute(file_contents('features/arc-ce/condor/job-transform-docker.config'), HTCONDOR_DOCKER_IMAGES),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', 'condor_reconfig'
);
