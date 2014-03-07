
unique template common/accounting/apel/parser_pbs;

include { 'common/accounting/apel/base' };

#Allow user to customize cron startup hour
#start after midnight so that torque logs are rotated
variable APEL_PARSER_TIME_HOUR ?= '1';

# Set to 3.0 if you want to use the new APEL parser
variable PUBLISHER_VERSION ?= "2.0";

# Include APEL PBS parser
include { 'common/accounting/apel/rpms/config' };

# ---------------------------------------------------------------------------- 
# cron
# ---------------------------------------------------------------------------- 
include { 'components/cron/config' };

"/software/components/cron/entries" = {
  if(APEL_ENABLED && PUBLISHER_VERSION == "2.0") {
  push(nlist(
    "name","apel-pbs-log-parser",
    "user","root",
    "frequency", "AUTO " + APEL_PARSER_TIME_HOUR + " * * *",
    "command", "/usr/bin/apel-pbs-log-parser -f " + APEL_PARSER_CONFIG,
    "env", nlist('RGMA_HOME', '/',
                 'APEL_HOME', '/',
                ),
	"log", nlist("mode","0644")
    ));
  } else if (APEL_ENABLED && PUBLISHER_VERSION == "3.0") {
      push(nlist("name","apel-pbs-log-parser",
                 "user","root",
                 "frequency", "AUTO " + APEL_PARSER_TIME_HOUR + " * * *",
                 "command", "/usr/bin/apelparser",
	         "log", nlist("mode","0644")
      ));
  };
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
# Apel Configuration File
# ---------------------------------------------------------------------------- 

variable APEL_CONFIG_INCLUDE = {
  if (PUBLISHER_VERSION == "2.0") {
    "common/accounting/apel/parser_config_xml";
  } else {
    "common/accounting/apel/parser_config_ini";
  };
};

include { APEL_CONFIG_INCLUDE };
