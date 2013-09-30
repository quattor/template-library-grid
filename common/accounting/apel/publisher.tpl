
unique template common/accounting/apel/publisher;

include { 'common/accounting/apel/base' };

variable APEL_ENABLED ?= true;
variable APEL_PUBLISHER_TIME_HOUR ?= '3';
variable APEL_PUBLISHER_TIME_MINUTE ?= '30';

# ---------------------------------------------------------------------------- 
# Cron entry for APEL publisher
# ---------------------------------------------------------------------------- 
include { 'components/cron/config' };
include { 'components/altlogrotate/config' }; 

"/software/components/cron/entries" =
  push_if(APEL_ENABLED,nlist(
    "name","apel-publisher",
    "user","root",
	"frequency", "AUTO " + APEL_PUBLISHER_TIME_HOUR + " * * *",
    "command", "env "+
               "RGMA_HOME="+GLITE_LOCATION+" "+
               "APEL_HOME="+GLITE_LOCATION+" "+
               GLITE_LOCATION+"/bin/apel-publisher -f "+ APEL_PUBLISHER_CONFIG,
	"log", nlist("mode","0644")
	)
);

"/software/components/altlogrotate/entries/apel-publisher" = 
  nlist("pattern", "/var/log/apel-publisher.ncm-cron.log",
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

"/software/components/apel/configFiles" = {

  # Create the configuration.
  data = nlist(
    "enableDebugLogging", "yes",
    "DBURL", "jdbc:mysql://"+ACCOUNTING_HOST+":3306/"+APEL_DB_NAME+"?jdbcCompliantTruncation=false",
    "DBUsername", APEL_DB_USER,
    "DBPassword", APEL_DB_PWD,
    "SiteName", SITE_NAME,

    "JoinProcessor", nlist("publishGlobalUserName",APEL_PUBLISH_USER_DN,
                           "Republish", APEL_REPUBLISH),
  );
  
  data['publishLimit'] = APEL_PUBLISH_LIMIT;

  SELF[escape(APEL_PUBLISHER_CONFIG)] = data;

  SELF;
};


# ---------------------------------------------------------------------------- 
# Fix APEL SPECRECORDS table for CEs using an external cluster
# To be removed when properly handled by APEL.
# ---------------------------------------------------------------------------- 

include {
  if (ACCOUNTING_HOST == FULL_HOSTNAME) {
    null;
  } else {
    'common/accounting/apel/hostingcluster_fix';
  };
};

