template features/arc-ce/largefiles;

include 'components/cron/config';
include 'components/filecopy/config';

'/software/components/cron/entries' = append(SELF, dict(
    'name', 'tier1-arc-large-files-remover',
    'user', 'root',
    'frequency', '*/10 * * * *',
    'command', '/usr/sbin/arc-largefiles-remover',
));

'/software/components/filecopy/services/{/usr/sbin/arc-largefiles-remover}' = dict(
    'config', file_contents('features/arc-ce/largefiles.sh'),
    'owner', 'root:root',
    'perms', '0744',
);
