unique template features/accounting/apel/parser_htcondorce;

#
# Base apel configuration
#

include 'features/accounting/apel/base';


#
# Apel configuration file
#

variable APEL_BLAH_LOGS_DIR ?= CONDOR_CONFIG['apel_output_dir'];
variable APEL_BLAH_PREFIX ?= 'blah-';

variable APEL_BATCH_LOGS_DIR ?= CONDOR_CONFIG['apel_output_dir'];
variable APEL_BATCH_PREFIX ?= 'batch-';
variable APEL_BATCH_TYPE = 'HTCondor';

include 'components/metaconfig/config';

prefix '/software/components/metaconfig/services';

'{/etc/apel/parser.cfg}' = dict(
    'mode', 0600,
    'owner', 'condor',
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
            'enabled', 'true',
            'dir', APEL_BLAH_LOGS_DIR,
            'filename_prefix', APEL_BLAH_PREFIX,
            'subdirs', 'false',
        ),

        'batch', dict(
	    'enabled', 'true',
            'reparse', 'false',
            'type', APEL_BATCH_TYPE,
            'parallel', to_string(APEL_MULTICORE_ENABLED),
            'dir', APEL_BATCH_LOGS_DIR,
            'filename_prefix', APEL_BATCH_PREFIX,
            'subdirs', 'false',
        ),

        'logging', dict(
            'logfile', '/var/log/apelparser.log',
            'level', 'INFO',
            'console', 'true',
        ),
    ),
);


#
# Packages
#

include 'components/spma/config';

prefix '/software/packages';

'{python-argparse}' = dict();
'{mariadb}' = dict();

