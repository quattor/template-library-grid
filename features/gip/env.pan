# Template defining GIP environment (directory layout).
# Used by other GIP configuration templates to limit dependencies between templates

unique template features/gip/env;

# glite GIP FLAVOR is the only supported flavor
variable GIP_FLAVOR ?= 'glite';

# If a resouce BDII is used, BDII configuration will define this variable with the appropriate value
variable RESOURCE_INFORMATION_URL ?= 'ldap://'+FULL_HOSTNAME+':'+to_string(GRIS_PORT)+'/mds-vo-name=local,o=grid';

# GIP_BASE_DIR is the directory containing /ldif, /plugin, ...
variable GIP_BASE_DIR ?= '/var/lib/bdii/gip';

# GIP_VAR_DIR is the directory containing cache, lock, tmp²
variable GIP_VAR_DIR ?= GLITE_LOCATION_VAR;

# Location of GLUE templates
variable GIP_GLUE_TEMPLATES_DIR ?= GLITE_LOCATION_ETC + '/glite/info/service';

# Location of GIP scripts
variable GIP_SCRIPTS_DIR ?= GLITE_LOCATION_BIN;
variable LCG_INFO_SCRIPTS_DIR ?= GLITE_LOCATION + '/libexec';

# Location of configuration files for GIP scripts
variable GIP_SCRIPTS_CONF_DIR ?= '/etc/bdii/gip';

# Location of LDIF files
variable GIP_LDIF_DIR ?= GIP_BASE_DIR + '/ldif';

# Location of GIP plugins
variable GIP_PLUGIN_DIR  ?= GIP_BASE_DIR + '/plugin';

# Location of GIP providers
variable GIP_PROVIDER_DIR = GIP_BASE_DIR + '/provider';

# Location of GIP cache
variable GIP_CACHE_DIR ?= GIP_BASE_DIR + '/cache/gip';

# Location of temporary files
variable GIP_TMP_DIR ?= GIP_BASE_DIR + '/tmp/gip';

# info-generic directory layout according to flavor
variable GIP_INFO_GENERIC_DIR = GIP_SCRIPTS_DIR + '/libexec';
variable GIP_INFO_SCRIPTS_PREFIX = 'glite-info-';

# Name of the provider to publish GlueService object (service independent)
variable GIP_PROVIDER_SERVICE ?= GIP_SCRIPTS_DIR + '/glite-info-service';

# Name of the LDIF file containing the GlueSite object
variable SITE_LDIF_FILE ?= 'static-file-Site.ldif';
