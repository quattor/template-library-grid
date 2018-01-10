
unique template features/accounting/apel/client;

include { 'features/accounting/apel/base' };

variable APEL_ENABLED ?= true;
variable APEL_CLIENT_TIME_HOUR ?= '3';
variable APEL_CLIENT_TIME_MINUTE ?= '30';

# ----------------------------------------------------------------------------
# Cron entry for APEL publisher
# ----------------------------------------------------------------------------
include { 'components/cron/config' };
include { 'components/altlogrotate/config' };

"/software/components/cron/entries" =
  push_if(APEL_ENABLED,nlist(
    "name","apelclient",
    "user","root",
	"frequency", "AUTO " + APEL_CLIENT_TIME_HOUR + " * * *",
    "command", "/usr/bin/apelclient",
	"log", nlist("mode","0644")
	)
);

"/software/components/altlogrotate/entries/apelclient" =
  nlist("pattern", "/var/log/apelclient.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "createparams", nlist(
        	"mode", "0644",
        	"owner", "root",
        	"group", "root"),
        "ifempty", true,
        "rotate", 2);


# ----------------------------------------------------------------------------
# APEL configuration
# ----------------------------------------------------------------------------

#Configuration file

include {'components/metaconfig/config'};
'/software/components/metaconfig/services/{/etc/apel/client.cfg}' = nlist(
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
       'spec_updater' ,nlist(
            'enabled', true,
            'site_name', SITE_NAME,
            'ldap_host', 'lcg-bdii.cern.ch',
            'ldap_port', 2170,
        ),
        'joiner', nlist(
            'enabled', true,
            'local_jobs', false,
        ),
        'unloader', nlist(
            'enabled', true,
            'dir_location', '/var/spool/apel/',
            'send_summaries',true,
            'withhold_dns',false,
            'interval', 'latest',
            'send_ur', false,
         ),
         'ssm', nlist(
         	'enabled', true,
         ),
        'logging', nlist(
            'logfile', '/var/log/apel/client.log',
            'level', 'INFO',
            'console', 'true',
        ),
    ),
);

