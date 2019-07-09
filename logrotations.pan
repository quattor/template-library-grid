template features/arc-ce/logrotations;

include 'components/altlogrotate/config';

prefix '/software/components/altlogrotate/entries';

'arc_gm-jobs' = dict(
    'pattern', '/var/log/arc/gm-jobs.log',
    'frequency', 'daily',
    'missingok', true,
    'rotate', 13,
    'compress', false,
);

'arc_ssmsend' = dict(
    'pattern', '/var/spool/arc/ssm/ssmsend.log',
    'frequency', 'weekly',
    'missingok', true,
    'rotate', 13,
    'compress', false,
);

'arc_logs2echo' = dict(
    'pattern', '/var/spool/arc/logs/logstos3.log',
    'frequency', 'daily',
    'missingok', true,
    'rotate', 13,
    'compress', false,
);


