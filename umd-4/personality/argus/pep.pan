unique template personality/argus/pep;

# Unique identifier  for the PEP
variable PEP_ENTITY_ID ?= 'http://' + PEP_HOST + '/pepd';

# PEP admin service port
variable PEP_ADMIN_PORT ?= 8155;

# PEP admin service password for shurtdown, clear cache, ..., commands
variable PEP_ADMIN_PASSWORD ?= undef;

# List of PDP endpoint URLs for the PEP to use
variable PEP_PDP_ENDPOINTS ?= list('https://' + PDP_HOST + ':' + to_string(PDP_PORT) + '/authz');

# Indicates whether to prefer a DN based mapping for the login name mapping
# over a primary FQAN login name mapping.
variable DNForAccountMapping ?= false;

variable PEP_LOCATION = ARGUS_LOCATION + '/pepd';
variable PEP_LOCATION_ETC = ARGUS_LOCATION_ETC + '/pepd';
variable PEP_LOCATION_LOG = ARGUS_LOCATION_LOG + '/pepd';
variable PEP_LOCATION_SBIN = PEP_LOCATION + '/sbin';

# PDP responses caching mechanism
# variable PEP_PDP_CACHE_ENABLED ?= true; # default
variable PEP_PDP_CACHE_ENABLED ?= false;  # recommended

# PEP daemon java options
# variable PEP_JAVA_OPTIONS ?= '-Xmx256M'; # default
variable PEP_JAVA_OPTIONS ?= '-Xmx1024M';  # recommended

#-----------------------------------------------------------------------------
# PEP Configuration
#-----------------------------------------------------------------------------

variable PEP_CONFIG_FILE = PEP_HOME + '/conf/pepd.ini';
variable PEP_CONFIG_CONTENTS = {
    contents = '#' + "\n";
    contents = contents + '# Argus PEP Server configuration' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '#  Documentation: https://twiki.cern.ch/twiki/bin/view/EGEE/AuthZPEPDConfig' + "\n";
    contents = contents + '# ' + "\n";
    contents = contents + '[SERVICE]' + "\n";
    contents = contents + 'entityId = ' + PEP_ENTITY_ID + "\n";
    contents = contents + 'hostname = ' + PEP_HOST + "\n";
    contents = contents + 'port = ' + to_string(PEP_PORT) + "\n";
    contents = contents + 'adminPort = ' + to_string(PEP_ADMIN_PORT) + "\n";
    if (is_defined(PEP_ADMIN_PASSWORD)) {
        contents = contents + 'adminPassword = ' + PEP_ADMIN_PASSWORD + "\n";
    };
    contents = contents + "\n";
    contents = contents + 'pips = REQVALIDATOR_PIP OPENSSLSUBJECT_PIP GLITEXACMLPROFILE_PIP COMMONXACMLPROFILE_PIP' + "\n";
    contents = contents + 'obligationHandlers = ACCOUNTMAPPER_OH' + "\n";
    contents = contents + "\n";
    contents = contents + '[PDP]' + "\n";
    contents = contents + 'pdps =';
    foreach (i; endpoint; PEP_PDP_ENDPOINTS) {
        contents = contents + ' ' + endpoint;
    };
    contents = contents + "\n";
    if (is_boolean(PEP_PDP_CACHE_ENABLED) && ! PEP_PDP_CACHE_ENABLED) {
        contents = contents + "# disable the cache\n";
        contents = contents + "maximumCachedResponses = 0\n";
    };
    contents = contents + "\n";
    contents = contents + '[SECURITY]' + "\n";
    contents = contents + 'servicePrivateKey = ' + SITE_DEF_HOST_KEY + "\n";
    contents = contents + 'serviceCertificate = ' + SITE_DEF_HOST_CERT + "\n";
    contents = contents + 'trustInfoDir = ' + SITE_DEF_CERTDIR + "\n";
    contents = contents + 'enableSSL = true' + "\n";
    contents = contents + 'requireClientCertAuthentication = true' + "\n";
    contents = contents + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '# Policy Information Points (PIP) configuration' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '[REQVALIDATOR_PIP]' + "\n";
    contents = contents + 'parserClass = org.glite.authz.pep.pip.provider.RequestValidatorPIPIniConfigurationParser' + "\n";
    contents = contents + 'validateRequestSubjects = true' + "\n";
    contents = contents + 'validateRequestResources = true' + "\n";
    contents = contents + 'validateRequestAction = true' + "\n";
    contents = contents + 'validateRequestEnvironment = false' + "\n";
    contents = contents + "\n";
    contents = contents + '[OPENSSLSUBJECT_PIP]' + "\n";
    contents = contents + 'parserClass = org.glite.authz.pep.pip.provider.OpenSSLSubjectPIPIniConfigurationParser' + "\n";
    contents = contents + 'opensslSubjectAttributeIDs = http://glite.org/xacml/attribute/subject-issuer urn:oasis:names:tc:xacml:1.0:subject:subject-id' + "\n";
    contents = contents + 'opensslSubjectAttributeDatatypes = http://www.w3.org/2001/XMLSchema#string' + "\n";
    contents = contents + "\n";
    contents = contents + '[GLITEXACMLPROFILE_PIP]' + "\n";
    contents = contents + 'parserClass = org.glite.authz.pep.pip.provider.GLiteAuthorizationProfilePIPIniConfigurationParser' + "\n";
    contents = contents + 'vomsInfoDir = ' + SITE_DEF_VOMSDIR + "\n";
    contents = contents + 'acceptedProfileIDs = http://glite.org/xacml/profile/grid-ce/1.0 http://glite.org/xacml/profile/grid-wn/1.0' + "\n";
    contents = contents + "\n";
    contents = contents + '[COMMONXACMLPROFILE_PIP]' + "\n";
    contents = contents + 'parserClass = org.glite.authz.pep.pip.provider.CommonXACMLAuthorizationProfilePIPIniConfigurationParser' + "\n";
    contents = contents + 'vomsInfoDir = ' + SITE_DEF_VOMSDIR + "\n";
    contents = contents + 'acceptedProfileIDs = http://dci-sec.org/xacml/profile/common-authz/1.1' + "\n";
    contents = contents + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '# Obligation Handlers (OH) configuration' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '[ACCOUNTMAPPER_OH]' + "\n";
    contents = contents + 'parserClass = org.glite.authz.pep.obligation.dfpmap.DFPMObligationHandlerConfigurationParser' + "\n";
    contents = contents + 'handledObligationId = http://glite.org/xacml/obligation/local-environment-map' + "\n";
    contents = contents + 'accountMapFile = ' + SITE_DEF_GRIDMAP + "\n";
    contents = contents + 'groupMapFile = ' + LCMAPS_CONFIG_DIR + "/groupmapfile\n";
    contents = contents + 'gridMapDir = ' + SITE_DEF_GRIDMAPDIR + "\n";
    contents = contents + 'useSecondaryGroupNamesForMapping = true' + "\n";

    contents;
};

include 'components/filecopy/config';
"/software/components/filecopy/services" = {
    SELF[escape(PEP_CONFIG_FILE)] = dict(
        "config", PEP_CONFIG_CONTENTS,
        "owner", "root",
        "perms", "0640",
    );
    SELF;
};


#-----------------------------------------------------------------------------
# PEP system configuration file
#-----------------------------------------------------------------------------

variable PEP_SYSCONFIG_FILE ?= '/etc/sysconfig/argus-pepd';
'/software/components/filecopy/services' = {
    this = <<EOF;
#
# Options for the Argus PEP server
#
#JAVACMD="/usr/bin/java"
# IPv4 instead of IPv6
#PEPD_JOPTS="-Djava.net.preferIPv4Stack=true"
PEPD_JOPTS=%s
#PEPD_HOME="/usr/share/argus/pepd"
#PEPD_CONF="/etc/argus/pepd/pepd.ini"
#PEPD_CONFDIR="/etc/argus/pepd"
#PEPD_LOGDIR="/var/log/argus/pepd"
#PEPD_LIBDIR="/var/lib/argus/pepd/lib"
#PEPD_ENDORSEDDIR="/var/lib/argus/pepd/lib/endorsed"
#PEPD_PROVIDEDDIR="/var/lib/argus/pepd/lib/provided"
#PEPD_PID="/var/run/argus-pepd.pid"

# OS provided dependencies (false to use embedded)
#PEPD_USE_OS_CANL="false"
#PEPD_USE_OS_BCPROV="false"
#PEPD_USE_OS_VOMS="false"
#PEPD_USE_OS_BCMAIL="false"
EOF
    SELF[escape(PEP_SYSCONFIG_FILE)] = dict(
        'config', format(this, PEP_JAVA_OPTIONS),
        'owner', 'root',
        'perms', '0640',
        'backup', false,
        'restart', '/sbin/service argus-pepd restart',
    );
    SELF;
};


#-----------------------------------------------------------------------------
# Fix temporary RPM issues
#-----------------------------------------------------------------------------

include 'components/dirperm/config';
'/software/components/dirperm/paths' = {
    append(dict(
        'path', PEP_LOCATION_ETC,
        'owner', 'root:root',
        'perm', '0750',
        'type', 'd',
    ));
    append(dict(
        'path', PEP_LOCATION_LOG,
        'owner', 'root:root',
        'perm', '0750',
        'type', 'd',
    ));
};
