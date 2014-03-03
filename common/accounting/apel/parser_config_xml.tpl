
unique template common/accounting/apel/parser_config_xml;

# ---------------------------------------------------------------------------- 
# Apel Configuration File
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

