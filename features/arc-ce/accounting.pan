template features/arc-ce/accounting;


include 'components/cron/config';
include 'components/filecopy/config';


'/software/packages' = pkg_repl('mysql-connector-python');

'/software/components/filecopy/services/{/usr/sbin/condorhistory2mysql}' = dict(
    'config', file_contents('features/arc-ce/condorhistory2mysql.py'),
    'owner', 'root:root',
    'perms', '0644',
);

'/software/components/cron/entries' ?= list();
'/software/components/cron/entries' = append(SELF, dict(
    'name', 'tier1-condor-history-to-mysql',
    'user', 'root',
    'frequency', '1 3 * * *',
    'command', 'python /usr/sbin/condorhistory2mysql',
));
