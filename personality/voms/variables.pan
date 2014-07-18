unique template personality/voms/variables;

variable VOMS_CERT_LAST_UPDATE ?= "2012092900";
variable VOMS_TOMCAT_USER    ?= "tomcat";
variable VOMS_TOMCAT_CERT    ?= "/etc/grid-security/tomcat-cert.pem";
variable VOMS_TOMCAT_CERTKEY ?= "/etc/grid-security/tomcat-key.pem";
variable VOMS_ROOT_CERT      ?= "/etc/grid-security/hostcert.pem";
variable VOMS_ROOT_CERTKEY   ?= "/etc/grid-security/hostkey.pem";

variable VOMS_TOMCAT_HOME       ?= "/usr/share/tomcat5";
variable VOMS_TOMCAT_COMMON_LIB ?= VOMS_TOMCAT_HOME+"/common/lib";
variable VOMS_TOMCAT_SERVER_LIB ?= VOMS_TOMCAT_HOME+"/server/lib";

variable VOMS_TOMCAT_MS ?= '375M';
variable VOMS_TOMCAT_MX ?= '750M';
variable VOMS_TOMCAT_MAXPERMSIZE ?= '1125m';
variable VOMS_TOMCAT_MANAGE_LIMITS_FILE ?= true;

variable VOMS_TOMCAT_RESTART_CONFIG ?= false;
