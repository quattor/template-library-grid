# Template defining all the MW components required to run a BDII

unique template glite/bdii/service;

variable LEMON_CONFIGURE_AGENT ?= false;

# Use OpenLDAP 2.4 by default
variable BDII_OPENLDAP24 ?= true;

# Define appropriate BDII type if not explicitly done
variable BDII_TYPE = {
    if ( !is_defined(BDII_TYPE)) {
        'resource';
    } else if ( BDII_TYPE == 'site' ) {
        'combined';
    } else {
        SELF;
    };
};


# Add BDII rpms
include { 'glite/bdii/rpms/config' + RPMS_SUFFIX };


# Configure gLite base environment
include { 'common/glite/env' };


# Configure BDII service
include { 'glite/bdii/config' };


# Configure GIP for BDII
include {'common/gip/bdii'};


# Configure GIP for BDII_subsite
include {
    if ( match(BDII_TYPE,'combined|site') && (length(BDII_SUBSITE) != 0) ) {
        'common/gip/subsite';
    };
};


# Configure GIP for BDII_site
include {
    if ( match(BDII_TYPE,'combined|site') && ((length(BDII_SUBSITE) == 0) || !BDII_SUBSITE_ONLY) ) {
        'common/gip/site';
    };
};


# Configure GIP for BDII_top
include {
    if ( BDII_TYPE == 'top' ) {
        'common/gip/top';
    };
};


# Add local GIP patch if defined
variable BDII_GIP_INCLUDE_LOCAL ?= undef;
include {
    if (is_defined(BDII_GIP_INCLUDE_LOCAL) && exists(BDII_GIP_INCLUDE_LOCAL)) {
        BDII_GIP_INCLUDE_LOCAL;
    };
};


# Lemon monitoring specific for BDII
include {
    if ( LEMON_CONFIGURE_AGENT ) {
        "monitoring/lemon/client/bdii/config";
    };
};
