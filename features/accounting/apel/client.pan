
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

include { 'components/apel/config' };

# If "yes" encrypt UserDNs with a 1024-bit RSA key
# If "no", UserDNs are not published (default)
# TODO: add a publicKeyLocation variable (if we want to use an external key
# for encryption.
variable APEL_PUBLISH_USER_DN ?= "no" ;

# Number of records that APEL will select in one go.
# The value of should be adjusted according to the memory 
# assigned to the Java VM. In general, for 512Mb the number 
# of records should be 150000 and for 1024Mb around 300000.
# The default value that is included in the APEL code is 
# 300000, as the default memory is 1024Mb. 
variable APEL_PUBLISH_LIMIT ?= 300000;

# If "missing" publish missing data only
# If "all" publish ALL accounting data in the database
# TODO: If "gap" publish data in a specified interval 
variable APEL_REPUBLISH = 'missing';

# Timeout for waiting for consumer in milliseconds
variable APEL_CONSUMER_TIMEOUT ?= "1800000";

variable ACCOUNTING_HOST ?= {
    if (is_defined(APEL_HOST)) {
      APEL_HOST;
    } else if (is_defined(MON_HOST)) {
      MON_HOST;
    } else {
      error('APEL_HOST and MON_HOST required but not specified');
    };
};




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

