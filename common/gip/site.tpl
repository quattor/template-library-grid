unique template common/gip/site;

variable SITE_DESC ?= 'EGI Site';
variable SITE_SECURITY_EMAIL ?= SITE_EMAIL;
variable SITE_USER_SUPPORT_EMAIL ?= SITE_EMAIL;

# The contents of this list is added to SITE_OTHER_INFO if defined and non empty.
variable SITE_OTHER_INFO_DEFAULT ?= nlist('GRID','EGI');

# Allow to define the hostname to use in the published endpoint for site BDII.
# This is useful to publish the DNS alias associated with the service, if any, rather
# than the actual host name.
variable BDII_ALIAS_SITE ?= FULL_HOSTNAME;

# New GLUE 2.0 parameter to identify if the site is geographically distributed
variable MW_SITE_DISTRIBUTED ?= 'no';

# Country of the site
variable SITE_COUNTRY ?= 'unknown';

# Include gip2 component
include { 'components/gip2/config' };

# Define GIP base configuration
include { 'common/gip/base' };

# List trusted (RPM provided) scripts
'/software/components/gip2/external' ?= list();
'/software/components/gip2/external' = {
    if (! is_list(SELF)) {
        error('/software/components/gip2/external must be an list');
    };
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-service-bdii-site'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-service-bdii-site-glue2'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-site'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-site-glue2'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-site-entry'));
    append(escape(GIP_PROVIDER_DIR + '/glite-info-provider-site-entry-glue2'));
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
    entries[escape('dn: mds-vo-name=' + SITE_NAME + ',o=grid')] = nlist(
        'objectclass', list('MDS'),
        'mds-vo-name', list(SITE_NAME),
    );
    if ( is_nlist(BDII_URLS_SITE) ) {
        foreach(k; v; BDII_URLS_SITE) {
            dnlist = split('[=,]', v);
            subsite = dnlist[1];
            entries[escape('dn: mds-vo-name=' + subsite + ',o=grid')] = nlist(
                'objectclass', list('MDS'),
                'mds-vo-name', list(subsite),
            );
            entries[escape('dn: mds-vo-name=' + subsite + ',mds-vo-name=' + SITE_NAME + ',o=grid')] = nlist(
                'objectclass', list('MDS'),
                'mds-vo-name', list(subsite),
            );
            # Glue v2
            entries[escape('dn: GLUE2DomainId=' + subsite + ',o=glue')] = nlist(
                'objectClass', list('GLUE2Domain'),
                'GLUE2DomainId', list(subsite),
            );
            entries[escape('dn: GLUE2DomainId=' + subsite + ',GLUE2DomainId=' + SITE_NAME + ',o=glue')] = nlist(
                'objectClass', list('GLUE2Domain', 'GLUE2AdminDomain'),
                'GLUE2DomainId', list(subsite),
                'GLUE2AdminDomainAdminDomainForeignKey', list(SITE_NAME),
            );
        };
    };
    SELF[SITE_LDIF_FILE] = entries;
    SELF;
};

# Create /etc/bdii/gip/site-urls.conf with the list of BDII URLs
'/software/components/gip2/confFiles' = {
    if ( is_defined(SELF) && !is_nlist(SELF)) {
        error('/software/components/gip2/confFiles must be an nlist');
    };
    urls = '';
    # BDII_URLS_SITE defines the subsite BDIIs consolidated by a site BDII.
    # Default is null as this feature is not used by standard sites.
    if ( is_defined(BDII_URLS_SITE) ) {
      foreach (name; url; BDII_URLS_SITE) {
          urls = urls + name + ' ' + url + "\n";
      };
    };
    SELF[escape(GIP_SCRIPTS_CONF_DIR + '/site-urls.conf')] = urls;
    SELF;        
};

# Create /etc/bdii/gip/glite-info-site-defaults.conf used by provider templates
'/software/components/gip2/confFiles' = {
    if ( is_defined(SELF) && !is_nlist(SELF)) {
        error('/software/components/gip2/confFiles must be an nlist');
    };
    SELF[escape(GIP_SCRIPTS_CONF_DIR + '/glite-info-site-defaults.conf')] =
        "SITE_NAME=" + SITE_NAME + "\n" +
        "SITE_BDII_HOST=" + BDII_ALIAS_SITE + "\n" +
        "BDII_PORT_READ=" + to_string(BDII_PORT) + "\n";
    SELF;
};

# Create /etc/glite-info-static/site/site.cfg used by glite-info-static
'/software/components/gip2/confFiles' = {
    # Merge SITE_OTHER_INFO_DEFAULT with SITE_OTHER_INFO, removing duplicates
    if ( exists(SITE_OTHER_INFO) ) {
        if ( is_nlist(SITE_OTHER_INFO) ) {
            site_other_info = SITE_OTHER_INFO;
        } else if ( is_list(SITE_OTHER_INFO) ) {
            site_other_info = nlist();
            foreach (k; v; SITE_OTHER_INFO) {
                toks = matches(v,'([\w\-]*)\s*=\s*(.*)');
                if ( length(toks) == 3 ) {
                    site_other_info[toks[1]] = toks[2];
                } else {
                    site_other_info[v] = undef;
                };
            };
        } else {
            error('SITE_OTHER_INFO must be a list or nlist');
        };
    } else {
        site_other_info = nlist();
    };
    if ( is_defined(SITE_OTHER_INFO_DEFAULT) ) {
        foreach (k; v; SITE_OTHER_INFO_DEFAULT) {
            if ( !exists(site_other_info[k]) ) {
                site_other_info[k] = v;
            };
        };
    };
    site_other_info_list = list();
    foreach (k; v; site_other_info) {
        if ( is_defined(v) ) {
            # If the value is a list, insert one element per value in the final list
            if ( is_list(v) ) {
                foreach (valnum; value; v) {
                    site_other_info_list[length(site_other_info_list)] = k + '=' + value;
                };
            } else {
                site_other_info_list[length(site_other_info_list)] = k + '=' + v;
            };
        } else {
            site_other_info_list[length(site_other_info_list)] = k;
        };
    };
    site_other_info_def = '';
    foreach(k; v; site_other_info_list) {
        site_other_info_def = site_other_info_def + "OTHERINFO=" + v + "\n";
    };
    SELF[escape('/etc/glite-info-static/site/site.cfg')] =
        "SITE_NAME=" + SITE_NAME + "\n" +
        "SITE_DESC=" + SITE_DESC + "\n" +
        "SITE_WEB=" + SITE_WEB + "\n" +
        "SITE_DISTRIBUTED=" + MW_SITE_DISTRIBUTED + "\n" +
        "SITE_LOC=" + SITE_LOC + "\n" +
        "SITE_COUNTRY=" + SITE_COUNTRY + "\n" +
        "SITE_LAT=" + to_string(SITE_LAT) + "\n" +
        "SITE_LONG=" + to_string(SITE_LONG) + "\n" +
        "SITE_EMAIL=" + SITE_EMAIL + "\n" +
        "SITE_SECURITY_EMAIL=" + SITE_SECURITY_EMAIL + "\n" +
        "SITE_SUPPORT_EMAIL=" + SITE_USER_SUPPORT_EMAIL + "\n" +
        site_other_info_def;
    SELF;
};


#
# Patch /etc/glite-info-static/site/site.glue1.tpl to publish site instead of resource data
#
variable CONTENTS = <<EOF;
#!/bin/sh

if grep -i mds-vo-name=resource /etc/glite-info-static/site/site.glue1.tpl > /dev/null 2>&1 ; then
    sed -i -e 's#mds-vo-name=resource#mds-vo-name=$SITE_NAME#ig' /etc/glite-info-static/site/site.glue1.tpl
fi
EOF

include {'components/filecopy/config'};
'/software/components/filecopy/services' = {
    if (length(BDII_SUBSITE) != 0) { 
        SELF[escape('/usr/local/sbin/patch-site-glue1.tpl.sh')] = nlist(
            'config', CONTENTS,
            'perms', '0744',
            'owner', 'root',
            'group', 'root',
            'backup', false,
            'restart', '/usr/local/sbin/patch-site-glue1.tpl.sh',
        );
    };
    if ( length(SELF) == 0 ) {
        null;
    } else {
        SELF;
    };
};
