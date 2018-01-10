unique template features/gip/subsite;

# For convenience. Test must be done on BDII_SUBSITE.
variable BDII_SUBSITE_FULL ?= SITE_NAME + '-' + BDII_SUBSITE;

# gip2
include { 'components/gip2/config' };

# Create /etc/bdii/gip/subsite-urls.conf with the list of BDII URLs
'/software/components/gip2/confFiles' ?= nlist();
'/software/components/gip2/confFiles' = {
    if (!is_nlist(SELF)) {
        error('/software/components/gip2/confFiles must be an nlist');
    };
    urls = '';
    foreach (name; url; BDII_URLS) {
        urls = urls + name + ' ' + url + "\n";
    };
    SELF[escape(GIP_SCRIPTS_CONF_DIR + '/subsite-urls.conf')] = urls;
    SELF;
};

# Create DNs for subsite entries
'/software/components/gip2/stubs' ?= nlist();
'/software/components/gip2/stubs' = {
    if (!is_nlist(SELF)) {
        error('/software/components/gip2/stubs must be an nlist');
    };
    if (is_nlist(SELF[SITE_LDIF_FILE])) {
        entries = SELF[SITE_LDIF_FILE];
    } else {
        entries = nlist();
    };
    entries[escape('dn: mds-vo-name=' + BDII_SUBSITE_FULL + ',o=grid')] = nlist(
        'objectclass', list('MDS'),
        'mds-vo-name', list(BDII_SUBSITE_FULL),
    );
    # Glue v2
    entries[escape('dn: GLUE2DomainId=' + BDII_SUBSITE_FULL + ',o=glue')] = nlist(
        'objectClass', list('GLUE2Domain'),
        'GLUE2DomainId', list(BDII_SUBSITE_FULL),
    );
    SELF[SITE_LDIF_FILE] = entries;
    SELF;
};

# Create subsite providers
'/software/components/gip2' = {
    SELF['provider']['glite-info-provider-subsite'] =
        '#!/bin/sh' + "\n\n" +
        'CONFIG=' + GIP_SCRIPTS_CONF_DIR + '/subsite-urls.conf' + "\n" +
        'SCRIPT=/usr/libexec/glite-info-provider-ldap' + "\n\n" +
        '# Check for the existence of the configuration file.' + "\n" +
        'if [ ! -f ${CONFIG} ]; then' + "\n" +
        '    echo "Error: The configuration file ${CONFIG} does not exist." 1>&2' + "\n" +
        '    exit 1' + "\n" +
        'fi' + "\n\n" +
        '# Check for the existence of the provider.' + "\n" +
        'if [ ! -f ${SCRIPT} ]; then' + "\n" +
        '    echo "Error: The provider ${SCRIPT} does not exist." 1>&2' + "\n" +
        '    exit 1' + "\n" +
        'fi' + "\n\n" +
        '${SCRIPT} -c ${CONFIG} -m ' + BDII_SUBSITE_FULL + "\n";
    # Create Glue v2 subsite provider
    SELF['provider']['glite-info-provider-subsite-glue2'] =
        '#!/bin/sh' + "\n\n" +
        'CONFIG=' + GIP_SCRIPTS_CONF_DIR + '/subsite-urls.conf' + "\n" +
        'SCRIPT=/usr/libexec/glite-info-provider-ldap' + "\n\n" +
        '# Check for the existence of the configuration file.' + "\n" +
        'if [ ! -f ${CONFIG} ]; then' + "\n" +
        '    echo "Error: The configuration file ${CONFIG} does not exist." 1>&2' + "\n" +
        '    exit 1' + "\n" +
        'fi' + "\n\n" +
        '# Check for the existence of the provider.' + "\n" +
        'if [ ! -f ${SCRIPT} ]; then' + "\n" +
        '    echo "Error: The provider ${SCRIPT} does not exist." 1>&2' + "\n" +
        '    exit 1' + "\n" +
        'fi' + "\n\n" +
        '${SCRIPT} -c ${CONFIG} -g ' + BDII_SUBSITE_FULL + "\n";
    SELF;
};
