unique template features/accounting/apel/parser_condor;

variable NEW_CONDOR_APEL_PARSER ?= false;

include 'features/accounting/apel/base';

variable LRMS_CONFIG_DIR ?= '/var/lib/condor';

# Allow user to customize cron startup hour
# ATTENTION: start after 3am to be sure that blah logs are rotated
variable APEL_PARSER_TIME_HOUR ?= '3';

variable APEL_PARSE_CRON_NAME ?= 'apel-condor-log-parser';

#
#Script for fixing the condor accounting
#
variable CONDOR_ACCOUNTING_FIX = if (NEW_CONDOR_APEL_PARSER){
    'features/accounting/apel/condor-accounting-fix.new'
} else {
    error('The old APEL parser is no longer supported.');
};

include 'components/filecopy/config';

'/software/components/filecopy/services/{/usr/bin/condor-accounting-fix}' = dict(
    'config', file_contents(CONDOR_ACCOUNTING_FIX),
    'perms', '0755',
);

include 'components/spma/config';

'/software/packages/{python-argparse}' = dict();


# cron
#
include 'components/cron/config';

'/software/components/cron/entries' = {
    push_if(APEL_ENABLED, dict(
        'name', APEL_PARSE_CRON_NAME,
        'user', 'root',
        'frequency', 'AUTO ' + APEL_PARSER_TIME_HOUR + ' * * *',
        'command', '/usr/bin/condor-accounting-fix && /usr/bin/apelparser',
        'env', dict(
            'RGMA_HOME', '/',
            'APEL_HOME', '/',
        ),
        'log', dict('mode', '0644'),
    ));
};

#
# altlogrotate
#
include 'components/altlogrotate/config';
'/software/components/altlogrotate/entries' = {
    SELF[ APEL_PARSE_CRON_NAME ] = dict(
        'pattern', '/var/log/' + APEL_PARSE_CRON_NAME + '.ncm-cron.log',
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
    SELF;
};

variable APEL_BLAH_LOGS_DIR ?= '/var/apel/accounting';

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
            'lrms_server', CE_HOST,
        ),
        'blah', dict(
            'enabled', to_string((index(FULL_HOSTNAME, CE_HOSTS) >= 0)),
            'dir', APEL_BLAH_LOGS_DIR,
            'filename_prefix', 'blahp.log',
            'subdirs', 'false',
        ),
        'batch', dict(
            'enabled', to_string((index(FULL_HOSTNAME, CE_HOSTS) >= 0)),
            'reparse', 'false',
            'type', 'HTCondor',
            'parallel', to_string(APEL_MULTICORE_ENABLED),
            'dir', LRMS_CONFIG_DIR + '/accounting',
            'filename_prefix', 'parsable.',
            'subdirs', 'false',
        ),
        'logging', dict(
            'logfile', '/var/log/apelparser.log',
            'level', 'INFO',
            'console', 'true',
        ),
    ),
);


include 'components/dirperm/config';


'/software/components/dirperm/paths' = push(dict(
    "owner", "root:root",
    "path", LRMS_CONFIG_DIR + '/accounting',
    "perm", '755',
    "type", "d"
));
