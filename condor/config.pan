template features/arc-ce/condor/config;

include 'components/filecopy/config';

# Blacklisted users
include 'features/arc-ce/condor/blacklists';

# Condor security configs
include 'features/arc-ce/condor/security';

# Jobs requiring xrootd access to Echo must specify this
include 'features/arc-ce/condor/echo-gateway';

# Common Condor configuration
include 'features/arc-ce/condor/service';

# use shared port
include 'features/arc-ce/condor/shared-port';

# Common Condor configuration
'/software/components/filecopy/services/{/etc/condor/condor_config}' = dict(
    'config', file_contents('features/arc-ce/condor/condor_config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', '/usr/sbin/condor_reconfig',
);

# Ensure condor_q behaves the old way in HTCondor 8.6.x
# still needed ? - 30 Jan 2019 - cc34
include 'features/arc-ce/condor/new-condor-arc-fix';

# configure accounting groups
include 'features/arc-ce/condor/accounting-groups';
