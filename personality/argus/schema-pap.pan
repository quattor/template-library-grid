unique template personality/argus/schema-pap;

#type pap_configuration_paps_properties = {
#  "pool_interval" : long
#  "ordering"      : string[] = list('default')
#};

#type pap_configuration_repository = {
#  "location"                 : path
#  "consistency_check"        : boolean
#  "consistency_check.repair" : boolean
#};

#type pap_configuration_security = {
#  "certificate" : path
#  "private_key" : path
#};

#type pap_configuration_standalone = {
#  "entity_id"     : uri
#  "hostname"      : hostname
#  "port"          : long
#  "shutdown_port" : long
#};

#type pap_configuration = {
#  "standalone-service" : pap_configuration_standalone
#  "security"           : pap_configuration_security
#  "repository"         : pap_configuration_repository
#  "paps:properties"    : pap_configuration_paps_properties
#  "paps"               : string{} = nlist()
#};
