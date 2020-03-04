template features/arc-ce/condor/perjobhistory;

include 'components/cron/config';
include 'components/dirperm/config';
include 'components/filecopy/config';


'/software/components/filecopy/services/{/etc/condor/config.d/24per-job-history-files.config}' = dict(
    'config', 'PER_JOB_HISTORY_DIR=/var/spool/condor/history',
    'backup', false,
    'owner', 'root:root',
    'restart', '/usr/sbin/condor_reconfig',
    'perms', '0644',
);

# Create directory for the per-job history files
'/software/components/dirperm/paths' = append(SELF, dict(
    'path', '/var/spool/condor/history',
    'owner', 'condor:condor',
    'perm', '0755',
    'type', 'd'
));

# Tidy up old history files
'/software/components/cron/entries' = {
    append(SELF, dict(
        'comment', 'Tidy up old history files',
        'name', 'tier1-condor-history-cleaner',
        'user', 'root',
        'frequency', '8 11 * * *',
        'command', '/usr/bin/find /var/spool/condor/history -name \* -mtime +5 -exec rm -fv {} \; >& /dev/null',
    ));
    append(SELF, dict(
        'comment', 'Tidy up old history files',
        'name', 'tier1-condor-history-cleaner-perjob',
        'user', 'root',
        'frequency', '8 14 * * *',
        'command', '/usr/bin/find /var/local/condor-history -name \* -mtime +90 -exec rm -f {} \; >& /dev/null',
    ));
    SELF;
};
