template features/arc-ce/condor/schedd;

include 'components/filecopy/config';

'/software/components/filecopy/services/{/etc/condor/config.d/21schedd.config}' = dict(
    'config', file_contents('features/arc-ce/condor/schedd.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', '/usr/sbin/condor_reconfig',
);
