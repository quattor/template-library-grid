template features/arc-ce/condor/new-condor-arc-fix;

include 'components/filecopy/config';
'/software/components/filecopy/services/{/etc/condor/config.d/66arc-new-condor-fix.config}' = dict(
    'config', file_contents('features/arc-ce/condor/arc-new-condor-fix.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
);
