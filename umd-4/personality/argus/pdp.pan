unique template personality/argus/pdp;

# Home directory for the PDP service
variable PDP_HOME ?= ARGUS_LOCATION + '/pdp';

# Unique identifier for the PEP
variable PDP_ENTITY_ID ?= 'http://' + PDP_HOST + '/pdp';

# PDP admin service port
variable PDP_ADMIN_PORT ?= 8153;

# PDP admin service password
variable PDP_ADMIN_PASSWORD ?= undef;

# The number of minutes the PDP will retain a policy from the PAP
variable PDP_RETENTION_INTERVAL ?= 240;

# A list of PAP endpoint URLs for the PDP to use
variable PDP_PAP_ENDPOINTS ?= list('https://' +  PAP_HOST + ':' + to_string(PAP_PORT) + '/pap/services/ProvisioningService');

variable PDP_LOCATION = ARGUS_LOCATION + '/pdp';
variable PDP_LOCATION_ETC = ARGUS_LOCATION_ETC + '/pdp';
variable PDP_LOCATION_LOG = ARGUS_LOCATION_LOG + '/pdp';
variable PDP_LOCATION_SBIN = PDP_LOCATION + '/sbin';


#-----------------------------------------------------------------------------
# PDP Configuration
#-----------------------------------------------------------------------------

variable PDP_CONFIG_FILE = PDP_HOME + '/conf/pdp.ini';
variable PDP_CONFIG_CONTENTS = {
    contents = "#\n";
    contents = contents + '# Argus PDP configuration' + "\n";
    contents = contents + '# ' + "\n";
    contents = contents + '# Documentation: https://twiki.cern.ch/twiki/bin/view/EGEE/AuthZPDPConfig' + "\n";
    contents = contents + '# ' + "\n";
    contents = contents + '[SERVICE]' + "\n";
    contents = contents + 'entityId = ' + PDP_ENTITY_ID + "\n";
    contents = contents + 'hostname = ' + PDP_HOST + "\n";
    contents = contents + 'port = ' + to_string(PDP_PORT) + "\n";
    contents = contents + 'adminPort = ' + to_string(PDP_ADMIN_PORT) + "\n";
    if (is_defined(PDP_ADMIN_PASSWORD)) {
        contents = contents + 'adminPassword = ' + PDP_ADMIN_PASSWORD + "\n";
    };
    contents = contents + "\n";
    contents = contents + '[POLICY]' + "\n";
    contents = contents + 'paps =';
    foreach (i; endpoint; PDP_PAP_ENDPOINTS) {
        contents = contents + ' ' + endpoint;
    };
    contents = contents + "\n";
    contents = contents + 'retentionInterval = ' + to_string(PDP_RETENTION_INTERVAL) + "\n";
    contents = contents + "\n";
    contents = contents + '[SECURITY]' + "\n";
    contents = contents + 'servicePrivateKey = ' +  SITE_DEF_HOST_KEY + "\n";
    contents = contents + 'serviceCertificate = ' + SITE_DEF_HOST_CERT + "\n";
    contents = contents + 'trustInfoDir = ' + SITE_DEF_CERTDIR + "\n";
    contents = contents + 'enableSSL = true' + "\n";

    contents;
};

include 'components/filecopy/config';

'/software/components/filecopy/services' = {
    npush(escape(PDP_CONFIG_FILE),
        dict(
            'config', PDP_CONFIG_CONTENTS,
            'owner', 'root',
            'perms', '0640',
            'restart', '/sbin/service pdp restart',
        )
    );
};

#-----------------------------------------------------------------------------
# Fix temporary RPM issues
#-----------------------------------------------------------------------------

include 'components/dirperm/config';

'/software/components/dirperm/paths' = {
    SELF[length(SELF)] = dict(
        'path', PDP_LOCATION_ETC,
        'owner', 'root:root',
        'perm', '0750',
        'type', 'd',
    );
    SELF[length(SELF)] = dict(
        'path', PDP_LOCATION_LOG,
        'owner', 'root:root',
        'perm', '0750',
        'type', 'd',
    );
    SELF;
};

