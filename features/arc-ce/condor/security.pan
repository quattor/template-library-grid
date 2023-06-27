template features/arc-ce/condor/security;

include 'components/filecopy/config';

'/software/components/filecopy/services/{/etc/condor/config.d/10security.config}' = dict(
    'config', file_contents('features/arc-ce/condor/security.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', '/usr/sbin/condor_reconfig',
);
