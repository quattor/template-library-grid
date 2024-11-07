template features/arc-ce/condor/blacklists;

include 'components/filecopy/config';

'/software/components/filecopy/services/{/etc/condor/config.d/13users-blacklists.config}' = dict(
    'config', file_contents('features/arc-ce/condor/users-blacklists.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', '/usr/sbin/condor_reconfig',
);
