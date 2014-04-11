unique template personality/bdii/config;

# Include base configuration for GIP
include { 'feature/gip/env' };

# Port used by BDII
variable BDII_PORT ?= 2170;

# BDII directories and files
variable BDII_LOCATION_VAR ?= '/var/lib/bdii';
variable BDII_LOG_FILE ?= '/var/log/bdii/bdii-update.log';
variable BDII_LOG_LEVEL ?= 'ERROR';


# SITE_BDII is the former variable used to select BDII type. Default was 'top'.
variable BDII_TYPE = {
    if ( !is_defined(SELF) ) {
        if ( is_defined(SITE_BDII) && SITE_BDII ) {
            bdii_type='site';
        } else {
            bdii_type='top';
        };
    } else {
        bdii_type = SELF;
    };
    debug('BDII_TYPE='+to_string(bdii_type));
    bdii_type;
};

# If defined to a non empty string BDII_SUBSITE means a site BDII used as information source by
# an official site BDII. This is used in distributed sites to allow a flexible
# management. Its value must be the subsite name, appended to the site name
# to build mds-vo-name.
# This variable is ignored if BDII_TYPE is not 'site'. Default is an
# empty string to simplify tests.
variable BDII_SUBSITE ?= '';

# When BDII_SUBSITE_ONLY is false, a subsite BDII is configured to act both
# as subsite and site BDII.
variable BDII_SUBSITE_ONLY ?= true;

# ----------------------------------------------------------------------------
# Define BDII config defaults depending on BDII type.
# Most of the default values are coming from YAIM : check config_bdii.
# BDII_TYPE=combined means a BDII acting both as a resource and site/subsite BDII
# ----------------------------------------------------------------------------
# If this is a site BDII (subsite undefined), configure as a combined BDII to publish site information
variable BDII_TYPE = {
    if ( (BDII_TYPE == 'site') && (length(BDII_SUBSITE) > 0) ) {
        'combined';
    } else {
        SELF;
    };
};

variable BDII_TYPE_OK = {
    if ( !match(BDII_TYPE,'combined|resource|site|top') ) {
        error('Invalid BDII type ('+BDII_TYPE+')');
    };
};

variable BDII_USER ?= 'ldap';
variable BDII_GROUP ?= BDII_USER;

# Time to wait for completion of a ldap request
variable BDII_READ_TIMEOUT ?= 300;

# This filter only affects search done directly by BDII, not those done by GIP.
variable BDII_SEARCH_FILTER  ?= '*';

variable BDII_BREATHE_TIME ?= {
    if ( BDII_TYPE == 'top' ) {
        120;
    } else {
        60;
    };
};

# The number of updates that the changes should be logged
variable BDII_ARCHIVE_SIZE ?= 0;

variable BDII_MODIFY_DN ?= false;

variable BDII_FIX_GLUE ?= 'yes';

variable BDII_FCR_URL ?= 'http://lcg-fcr.cern.ch:8083/fcr-data/exclude.ldif';
variable BDII_USE_FCR ?= {
    if ( length(BDII_FCR_URL) > 0 && BDII_TYPE == 'top') {
        true;
    } else {
        false;
    };
};

variable BDII_MDS_VO_NAME = {
    if ( match(BDII_TYPE,'combined|site') ) {
        if ( (length(BDII_SUBSITE) > 0) && BDII_SUBSITE_ONLY ) {
            'mds-vo-name=' + SITE_NAME + '-' + BDII_SUBSITE + ',o=grid';
        } else {
            'mds-vo-name=' + SITE_NAME + ',o=grid';
        };
    } else if ( BDII_TYPE == 'resource' ) {
        'mds-vo-name=resource,o=grid';
    } else if ( BDII_TYPE == 'top' ) {
        'mds-vo-name=local,o=grid';
    };
};

variable RESOURCE_INFORMATION_URL = {
    if ( match(BDII_TYPE,'combined|resource') ) {
        'ldap://'+FULL_HOSTNAME+':'+to_string(BDII_PORT)+'/' + BDII_MDS_VO_NAME;
    } else {
        null;
    };
};

variable BDII_SLAPD_CONF_FILE = {
    if ( BDII_TYPE == 'top' ) {
        '/etc/bdii/bdii-top-slapd.conf';
    } else {
        '/etc/bdii/bdii-slapd.conf';
    };
};

# ----------------------------------------------------------------------------
# chkconfig
# ----------------------------------------------------------------------------
include { 'components/chkconfig/config' };
"/software/components/chkconfig/service/bdii/on" = "";
"/software/components/chkconfig/dependencies/pre" = push("lcgbdii");

# ----------------------------------------------------------------------------
# accounts
# If BDII_TYPE=resource, take care of defining GIP user to match BDII_USER and
# updating GIP configuration, if already done.
#
# Also add BDII_USER to glite group to ensure it has access to GLITE_LOCATION_VAR.
# ----------------------------------------------------------------------------
include { 'users/' + BDII_USER };
"/software/components/lcgbdii/dependencies/pre" = push("accounts");


# ----------------------------------------------------------------------------
# Keep BDII DB in tmpfs
# ----------------------------------------------------------------------------
variable BDII_RAM_DISK ?= {
    if ( BDII_TYPE == 'top' ) {
        'yes';
    } else {
        null;
    };
};


# ----------------------------------------------------------------------------
# How long to cache data
# ----------------------------------------------------------------------------
variable BDII_DELETE_DELAY ?= {
    if ( BDII_TYPE == 'top' ) {
        345600;
    } else {
        0;
    };
};


# ----------------------------------------------------------------------------
# Use openldap-2.4
# ----------------------------------------------------------------------------
variable BDII_SLAPD ?= {
    if (is_boolean(BDII_OPENLDAP24) && BDII_OPENLDAP24 && is_defined(OS_VERSION_PARAMS['majorversion']) && OS_VERSION_PARAMS['majorversion'] == '5') {
        '/usr/sbin/slapd2.4';
    } else {
        null;
    };
};


# ----------------------------------------------------------------------------
# iptables
# ----------------------------------------------------------------------------
include { 'components/iptables/config' };

# Inbound port(s).
'/software/components/iptables/filter/rules' = push(
    nlist('command', '-A',
        'chain', 'input',
        'match', 'state',
        'state', 'NEW',
        'protocol', 'tcp',
        'dst_port', to_string(BDII_PORT),
        'target', 'accept',
    )
);


# ----------------------------------------------------------------------------
# hostsaccess
# ----------------------------------------------------------------------------
include { 'components/hostsaccess/config' };

# This MUST be in the host.allow file or the BDII will not be accessible.
'/software/components/hostsaccess/allow' = push(
    nlist('daemon', 'slapd', 'host', '127.0.0.1')
);


# -----------------------------------------------------------------------------
# lcgbdii configuration
# -----------------------------------------------------------------------------
include { 'components/lcgbdii/config' };
'/software/components/lcgbdii/archiveSize' = BDII_ARCHIVE_SIZE;
'/software/components/lcgbdii/breatheTime' = BDII_BREATHE_TIME;
'/software/components/lcgbdii/configFile' = GLITE_LOCATION_ETC + '/bdii/bdii.conf';
'/software/components/lcgbdii/deleteDelay' = BDII_DELETE_DELAY;
'/software/components/lcgbdii/ldifDir' = GIP_LDIF_DIR;
'/software/components/lcgbdii/logFile' = BDII_LOG_FILE;
'/software/components/lcgbdii/logLevel' = BDII_LOG_LEVEL;
'/software/components/lcgbdii/pluginDir' = GIP_PLUGIN_DIR;
'/software/components/lcgbdii/port' = BDII_PORT;
'/software/components/lcgbdii/providerDir' = GIP_PROVIDER_DIR;
'/software/components/lcgbdii/RAMDisk' = BDII_RAM_DISK;
'/software/components/lcgbdii/readTimeout' = BDII_READ_TIMEOUT;
'/software/components/lcgbdii/slapd' = BDII_SLAPD;
'/software/components/lcgbdii/slapdConf' = BDII_SLAPD_CONF_FILE;
'/software/components/lcgbdii/user' = BDII_USER;
'/software/components/lcgbdii/varDir' = BDII_LOCATION_VAR;
