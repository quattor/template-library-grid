
unique template feature/accounting/apel/publisher_ActiveMQ;

include { 'security/cas' }; # Add accepted CAs certificates
include { 'features/fetch-crl/config' }; # Update the certificate revocation lists.
include { 'feature/accounting/apel/base' };

#rpms
include { "rpms/ruby"};

variable APEL_ENABLED ?= true;
variable APEL_PUBLISHER_TIME_HOUR ?= '3';
variable APEL_PUBLISHER_TIME_MINUTE ?= '30';

# Number of records that APEL will select in one go.
# The value of should be adjusted according to the memory 
# assigned to the Java VM. In general, for 512Mb the number 
# of records should be 150000 and for 1024Mb around 300000.
# Modify this value if OutOfMemory error appears in the Publisher.
variable APEL_PUBLISH_LIMIT ?= 300000;
 
# If "missing", publish missing data only.
# If "all", publish ALL accounting data in the database.
# If "gap", publish data in a specified interval (not yet supported).
variable APEL_REPUBLISH = "missing";

# Timeout for waiting for consumer in milliseconds
variable APEL_CONSUMER_TIMEOUT ?= 1800000;

variable APEL_MAX_INSERT_BATCH ?= 2000;

# If "no", UserDNs are not published.
# If "yes", encrypt UserDNs with a 1024-bit RSA key. It uses the APEL key by
# default.
variable APEL_PUBLISH_USER_DN ?= "no";

# if set, this external public key will be used for UserDNs encryption.
variable APEL_PUBLIC_KEY_LOCATION ?= '';

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
               "APEL_HOME=/ "+
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

"/software/components/apel/configFiles" = {

  # Create the configuration.
  data = nlist(
    "enableDebugLogging", "yes",
    "DBURL", "jdbc:mysql://"+MON_HOST+":3306/"+APEL_DB_NAME+"?jdbcCompliantTruncation=false",
    "DBUsername", APEL_DB_USER,
    "DBPassword", APEL_DB_PWD,
    "SiteName", SITE_NAME,
    "MaxInsertBatch", APEL_MAX_INSERT_BATCH,
    "ConsumerTimeout", APEL_CONSUMER_TIMEOUT,
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
# Update : apel publisher is now correctly handling things, just leave this for reference.
# ----------------------------------------------------------------------------
variable APEL_HOSTINGCLUSTER_FIX ?= false;
include { if(APEL_HOSTINGCLUSTER_FIX){ 'feature/accounting/apel/hostingcluster_fix' } else { null } ; };

#
# EMI addendums
#

#copy the publisher exe to its place :

'/software/components/filecopy/services' = npush(
	escape('/usr/bin/apel-publisher'), nlist( 'source','/usr/bin/apel-publisher_tmp',
        'owner', 'root:root',
        'perms','0754',
         )
    );
