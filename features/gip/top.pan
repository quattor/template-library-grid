# Configure GIP on a top BDII.

unique template features/gip/top;

# Allow to define the hostname to use in the published endpoint for site and top BDII.
# This is useful to publish the DNS alias associated with the service, if any, rather
# than the actual host name.
variable BDII_ALIAS_TOP ?= FULL_HOSTNAME;

include { 'components/gip2/config' };

# Define GIP base configuration
include { 'features/gip/base' };

# Default FCR URL
variable BDII_FCR_URL ?= 'http://lcg-fcr.cern.ch:8083/fcr-data/exclude.ldif';

# List trusted (RPM provided) scripts
"/software/components/gip2/external" ?= list();
"/software/components/gip2/external" = {
    if (! is_list(SELF)) {
        error('/software/components/gip2/external must be an list');
    };
    append(escape(GIP_PLUGIN_DIR + '/glite-info-plugin-fcr'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-service-bdii-top'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-service-bdii-top-glue2'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-top'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-top-glue2'));
};

# Configuration files
'/software/components/gip2/confFiles' ?= nlist();
'/software/components/gip2/confFiles' = {
    if (! is_nlist(SELF)) {
        error('/software/components/gip2/confFiles must be an nlist');
    };
    SELF[escape(GIP_SCRIPTS_CONF_DIR + '/glite-info-site-defaults.conf')] =
        "SITE_NAME=" + SITE_NAME + "\n" +
        "BDII_HOST=" + BDII_ALIAS_TOP + "\n" +
        "BDII_PORT_READ=" + to_string(BDII_PORT) + "\n" +
        "BDII_UPDATE_LDIF=" + BDII_FCR_URL + "\n";
    SELF;
};
