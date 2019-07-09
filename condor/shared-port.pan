template features/arc-ce/condor/shared-port;

include 'components/filecopy/config';

'/software/components/filecopy/services/{/etc/condor/config.d/33shared-port.config}' = dict(
    'config', file_contents('features/arc-ce/condor/shared-port.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
);
