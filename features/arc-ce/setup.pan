template features/arc-ce/setup;

include 'components/dirperm/config';

'/software/components/dirperm/paths' = {
    dirs = list(
        '/var/spool/arc/jobstatus',
        '/var/spool/arc/grid00',
        '/var/spool/arc/grid01',
        '/var/spool/arc/grid02',
        '/var/spool/arc/grid03',
        '/var/spool/arc/grid04',
        '/var/spool/arc/grid05',
        '/var/spool/arc/grid06',
        '/var/spool/arc/grid07',
        '/var/spool/arc/grid08',
        '/var/spool/arc/grid09',
        '/var/spool/arc/grid10',
        '/var/spool/arc/grid11',
        # Accounting
        '/var/spool/arc/ssm',
        '/var/run/arc/urs',
        '/var/spool/arc/logs',
    );

    foreach (i; path; dirs) {
        append(SELF, dict(
            'path', path,
            'owner', 'root:root',
            'perm', '0755',
            'type', 'd'
        ));
    };
    SELF;
};
