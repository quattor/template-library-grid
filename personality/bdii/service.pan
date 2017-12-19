# Template defining all the MW components required to run a BDII

unique template personality/bdii/service;

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
include { 'personality/bdii/rpms/config' };


# Configure gLite base environment
include { 'features/grid/env' };


# Configure BDII service
include { 'personality/bdii/config' };


# Configure GIP for BDII
include {'features/gip/bdii'};


# Configure GIP for BDII_subsite
include {
    if ( match(BDII_TYPE,'combined|site') && (length(BDII_SUBSITE) != 0) ) {
        'features/gip/subsite';
    };
};


# Configure GIP for BDII_site
include {
    if ( match(BDII_TYPE,'combined|site') && ((length(BDII_SUBSITE) == 0) || !BDII_SUBSITE_ONLY) ) {
        'features/gip/site';
    };
};


# Configure GIP for BDII_top
include {
    if ( BDII_TYPE == 'top' ) {
        'features/gip/top';
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
