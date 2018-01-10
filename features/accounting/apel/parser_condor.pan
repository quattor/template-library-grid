unique template features/accounting/apel/parser_condor;

include { 'features/accounting/apel/base' };
# Fixme: Just to avoid full rewritting
variable LRMS_CONFIG_DIR ?= if (exists(TORQUE_CONFIG_DIR)) {
    TORQUE_CONFIG_DIR;
} else {
    '/var/lib/condor';
};

#
# Allow user to customize cron startup hour
# ATTENTION: start after 3am to be sure that blah logs are rotated
variable APEL_PARSER_TIME_HOUR ?= '3';

variable APEL_PARSE_CRON_NAME ?= 'apel-condor-log-parser';

#
#Script for fixing the condor accounting
#
include {'components/filecopy/config'};

'/software/components/filecopy/services/{/usr/bin/condor-accounting-fix}' = nlist(
                                'config', file_contents('features/accounting/apel/condor-accounting-fix'),
                                'perms', '0755',
);

include {'components/spma/config'};

'/software/packages/{python-argparse}' = nlist();

#
# cron
#
include { 'components/cron/config' };
'/software/components/cron/entries' = {
    push_if(APEL_ENABLED, nlist(
        'name', APEL_PARSE_CRON_NAME,
        'user', 'root',
        'frequency', 'AUTO ' + APEL_PARSER_TIME_HOUR + ' * * *',
        'command', '/usr/bin/condor-accounting-fix && /usr/bin/apelparser',
        'env', nlist(
            'RGMA_HOME', '/',
            'APEL_HOME', '/',
        ),
        'log', nlist('mode', '0644'),
    ));
};

#
# altlogrotate
#
include { 'components/altlogrotate/config' };
'/software/components/altlogrotate/entries/' = {
	SELF[ APEL_PARSE_CRON_NAME ]= nlist(
    	      'pattern', '/var/log/'+APEL_PARSE_CRON_NAME+'.ncm-cron.log',
    	      'compress', true,
    	      'missingok', true,
    	      'frequency', 'weekly',
    	      'create', true,
    	      'createparams', nlist(
	                    'mode', '0644',
              		    'owner', 'root',
              		    'group', 'root',
    	      		    ),
    	      'ifempty', true,
    	      'rotate', 2,
	      );
	SELF;
};

#
# Configuration file
#
include {'components/metaconfig/config'};
'/software/components/metaconfig/services/{/etc/apel/parser.cfg}' = nlist(
    'mode', 0600,
    'owner', 'root',
    'group', 'root',
    'module', 'tiny',
    'contents', nlist(
        'db', nlist(
            'hostname', MON_HOST,
            'port', 3306,
            'name', APEL_DB_NAME,
            'username', APEL_DB_USER,
            'password', APEL_DB_PWD,
        ),
        'site_info', nlist(
            'site_name', SITE_NAME,
            'lrms_server', CE_HOST,
        ),
        'blah', nlist(
            'enabled', to_string((index(FULL_HOSTNAME, CE_HOSTS) >= 0)),
            'dir', '/var/apel/accounting',
            'filename_prefix', 'blahp.log',
            'subdirs', 'false',
        ),
        'batch', nlist(
#            'enabled', to_string(match(FULL_HOSTNAME, CE_HOST)),
	     'enabled', to_string((index(FULL_HOSTNAME, CE_HOSTS) >= 0)),
            'reparse', 'false',
            'type', 'PBS',
            'parallel', to_string(APEL_MULTICORE_ENABLED),
            'dir', LRMS_CONFIG_DIR + '/server_priv/accounting',
            'filename_prefix', '20',
            'subdirs', 'false',
        ),
        'logging', nlist(
            'logfile', '/var/log/apelparser.log',
            'level', 'INFO',
            'console', 'true',
        ),
    ),
);
