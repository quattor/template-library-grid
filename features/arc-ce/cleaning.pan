template features/arc-ce/cleaning;

include 'components/cron/config';

# Tidy up archived accounting records
'/software/components/cron/entries' = {
    append(SELF, dict(
        'comment', 'Tidy up archived accounting records',
        'name', 'tier1-arc-accounting-cleaner',
        'user', 'root',
        'frequency', '8 12 * * *',
        'command', '/usr/bin/find /var/run/arc/urs/ -name \* -mtime +7 -exec rm -fv {} \; >& /dev/null',
    ));
    append(SELF, dict(
        'comment', 'Tidy up archived accounting records',
        'name', 'tier1-arc-jobstatus-cleaner',
        'user', 'root',
        'frequency', '8 11 * * *',
        'command', '/usr/bin/find /var/spool/arc/jobstatus/ -name \* -mtime +14 -exec rm -f {} \; >& /dev/null',
    ));
    SELF;
};
