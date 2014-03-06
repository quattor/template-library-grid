
unique template feature/accounting/apel/parser_pbs;

include { 'feature/accounting/apel/base' };

#Allow user to customize cron startup hour
#start after midnight so that torque logs are rotated
variable APEL_PARSER_TIME_HOUR ?= '1';

# Include APEL PBS parser
include { 'feature/accounting/apel/rpms/parser_pbs' };

# ---------------------------------------------------------------------------- 
# cron
# ---------------------------------------------------------------------------- 
include { 'components/cron/config' };

"/software/components/cron/entries" = {
  push_if(APEL_ENABLED,nlist(
    "name","apel-pbs-log-parser",
    "user","root",
    "frequency", "AUTO " + APEL_PARSER_TIME_HOUR + " * * *",
    "command", "/usr/bin/apel-pbs-log-parser -f " + APEL_PARSER_CONFIG,
    "env", nlist('RGMA_HOME', '/',
                 'APEL_HOME', '/',
                ),
	"log", nlist("mode","0644")
    ));
};


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
include { 'components/altlogrotate/config' }; 

"/software/components/altlogrotate/entries/apel-pbs-log-parser" = 
  nlist("pattern", "/var/log/apel-pbs-log-parser.ncm-cron.log",
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
# apel
# ---------------------------------------------------------------------------- 
include { 'components/apel/config' };
variable INSPECT_TABLES = if(APEL_DB_INSPECT) { "yes" } else { "no" } ;

"/software/components/apel/configFiles" = {

  # Create the configuration.
  if(is_defined(SITE_BDII_HOST)) {_bdii=SITE_BDII_HOST } else {_bdii=GIP_CLUSTER_PUBLISHER_HOST};
  SELF[escape(APEL_PARSER_CONFIG)] = nlist("enableDebugLogging", "yes",
                                           "inspectTables", INSPECT_TABLES,
                                           "DBURL", "jdbc:mysql://"+MON_HOST+":3306/"+APEL_DB_NAME+"?jdbcCompliantTruncation=false",
                                           "DBUsername", APEL_DB_USER,
                                           "DBPassword", APEL_DB_PWD,
                                           "SiteName", SITE_NAME,     
                                           "CPUProcessor", nlist("GIIS", _bdii),
                                           "EventLogProcessor", nlist("searchSubDirs", "yes",
                                                                       "reprocess", "no",
                                                                       "Dir", TORQUE_CONFIG_DIR+"/server_priv/accounting",
                                                                       "Timezone", "UTC"),
                                          );

  if ( index(FULL_HOSTNAME,CE_HOSTS) >= 0 ) {
    SELF[escape(APEL_PARSER_CONFIG)]["GKLogProcessor"] = nlist("SubmitHost",FULL_HOSTNAME,
                                                               "searchSubDirs","yes",
                                                               "reprocess", "no",
                                                               "GKLogs",list("/var/log"),
                                                               "MessageLogs", list("/var/log"),
                                                              );
  };
  
  SELF;
};

