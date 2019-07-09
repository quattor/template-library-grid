template features/arc-ce/fetch-crl;

include 'components/cron/config';

'/software/components/cron/entries' = append(SELF, dict(
    'comment', 'Run fetch-crl more often',
    'name', 'fetch-crl',
    'user', 'root',
    'frequency', '42 */2 * * *',
    'command', '/usr/sbin/fetch-crl -q -r 360 >> /var/log/fetchcrl.log 2>&1',
));
