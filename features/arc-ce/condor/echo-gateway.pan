template features/arc-ce/condor/echo-gateway;

include 'components/filecopy/config';

'/software/components/filecopy/services/{/etc/condor/config.d/29echo-gateway.config}' = dict(
    'config', file_contents('features/arc-ce/condor/echo-gateway.config'),
    'backup', false,
    'owner', 'root:root',
    'perms', '0644',
    'restart', '/usr/sbin/condor_reconfig',
);
