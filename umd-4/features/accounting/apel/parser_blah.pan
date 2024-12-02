unique template features/accounting/apel/parser_blah;

include 'features/accounting/apel/base';

#
# Allow user to customize cron startup hour
# start after midnight so that torque logs are rotated
variable APEL_PARSER_TIME_HOUR ?= '1';

#
# cron
#
include 'components/cron/config';
'/software/components/cron/entries' = {
    push_if(APEL_ENABLED, dict(
        'name', 'apel-pbs-log-parser',
        'user', 'root',
        'frequency', 'AUTO ' + APEL_PARSER_TIME_HOUR + ' * * *',
        'command', '/usr/bin/apelparser',
        'log', dict('mode', '0644'),
    ));
};

#
# altlogrotate
#
include 'components/altlogrotate/config';
'/software/components/altlogrotate/entries/apel-pbs-log-parser' = dict(
    'pattern', '/var/log/apel-pbs-log-parser.ncm-cron.log',
    'compress', true,
    'missingok', true,
    'frequency', 'weekly',
    'create', true,
    'createparams', dict(
        'mode', '0644',
        'owner', 'root',
        'group', 'root',
    ),
    'ifempty', true,
    'rotate', 2,
);

#
# Configuration file
#
include 'components/metaconfig/config';
'/software/components/metaconfig/services/{/etc/apel/parser.cfg}' = dict(
    'mode', 0600,
    'owner', 'root',
    'group', 'root',
    'module', 'tiny',
    'contents', dict(
        'db', dict(
            'hostname', MON_HOST,
            'port', 3306,
            'name', APEL_DB_NAME,
            'username', APEL_DB_USER,
            'password', APEL_DB_PWD,
        ),
        'site_info', dict(
            'site_name', SITE_NAME,
            'lrms_server', LRMS_SERVER_HOST,
        ),
        'blah', dict(
            'enabled', to_string((index(FULL_HOSTNAME, CE_HOSTS) >= 0)),
            'dir', BLAH_LOG_DIR,
            'filename_prefix', 'blahp.log',
            'subdirs', 'false',
        ),
        'batch', dict(
            'enabled', to_string(match(FULL_HOSTNAME, LRMS_SERVER_HOST)),
            'reparse', 'false',
            'type', 'PBS',
            'parallel', to_string(APEL_MULTICORE_ENABLED),
            'dir', TORQUE_CONFIG_DIR + '/server_priv/accounting',
            'filename_prefix', '20',
            'subdirs', 'false',
        ),
        'logging', dict(
            'logfile', '/var/log/apelparser.log',
            'level', 'INFO',
            'console', 'true',
        ),
    ),
);
