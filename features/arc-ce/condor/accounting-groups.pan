template features/arc-ce/condor/accounting-groups;

include 'components/filecopy/config';

'/software/components/filecopy/services/{/etc/condor/config.d/14accounting-groups.config}' = dict(
    'config', file_contents('features/arc-ce/condor/accounting-groups.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', '/usr/sbin/condor_reconfig -daemon schedd',
);
