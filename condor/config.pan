template features/arc-ce/condor/config;

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

# configure accounting groups
include 'features/arc-ce/condor/accounting-groups';
