unique template personality/argus/pap;

# List of external PAPS
variable PAPS ?= nlist();

# Unique identifier for the PAP
variable PAP_ENTITY_ID ?= "http://" + PAP_HOST + "/pap";

# Path to the repository directory
variable PAP_REPO_LOCATION ?= PAP_HOME + '/repository';

# The polling interval (in seconds) for retrieving remote policies
variable PAP_POLL_INTERVAL ?= 14400;

# Space separated list of PAP aliases.
variable PAP_ORDERING ?= 'default';
variable PAP_ORDERING_LIST ?= list('default');

# Forces a consistency check of the repository at startup
variable PAP_CONSISTENCY_CHECK ?= 'false';

# Automatically fixes problems detected by the consistency check
variable PAP_CONSISTENCY_CHECK_REPAIR ?= 'false';

# PAP standalone shutdown service port
variable PAP_SHUTDOWN_PORT ?= 8151;

# PAP standalone shutdown command (password)
variable PAP_SHUTDOWN_COMMAND ?= undef;

# User certificate DN of the users that will be the PAP administrator.
variable PAP_ADMIN_DN ?= list();
variable PAP_HOST_DN ?= error('PAP_HOST_DN required but undefined');

variable PAP_LOCATION = ARGUS_LOCATION + '/pap';
variable PAP_LOCATION_ETC = ARGUS_LOCATION_ETC + '/pap';
variable PAP_LOCATION_LOG = ARGUS_LOCATION_LOG + '/pap';
variable PAP_LOCATION_SBIN = PAP_LOCATION + '/sbin';


#-----------------------------------------------------------------------------
# PAP Configuration
#-----------------------------------------------------------------------------

variable PAP_CONFIG_FILE = PAP_HOME + '/conf/pap_configuration.ini';
variable PAP_CONFIG_CONTENTS = {
  contents = "#\n";
  contents = contents + '# PAP configuration' + "\n";
  contents = contents + '# ' + "\n";
  contents = contents + '# Documentation: https://twiki.cern.ch/twiki/bin/view/EGEE/AuthZPAPConfig' + "\n";
  contents = contents + '# ' + "\n";
  contents = contents + '[paps]' + "\n";
  contents = contents + '## Trusted PAPs will be listed here' + "\n";
  ok = first(PAPS,name,properties);
  while (ok) {
    contents = contents + name + '.type = '    + properties['type']               + "\n";
    contents = contents + name + '.enabled = ' + to_string(properties['enabled']) + "\n";
    contents = contents + name + '.dn = '      + properties['dn']                 + "\n";
    contents = contents + name + '.hostname = '+ properties['hostname']           + "\n";
    contents = contents + name + '.port = '    + to_string(properties['port'])    + "\n";
    contents = contents + name + '.path = '    + properties['path']               + "\n";
    contents = contents + name + '.protocol = '+ properties['protocol']           + "\n";
    contents = contents + name + '.public = '  + to_string(properties['public'])  + "\n";
    ok = next(PAPS,name,properties);
  };
  contents = contents + "\n";
  contents = contents + '[paps:properties]' + "\n";
  contents = contents + 'poll_interval = ' + to_string(PAP_POLL_INTERVAL) + "\n";
  contents = contents + 'ordering = ' + PAP_ORDERING + "\n";
  contents = contents + "\n";
  contents = contents + '[repository]' + "\n";
  contents = contents + 'location = ' + PAP_REPO_LOCATION + "\n";
  contents = contents + 'consistency_check = ' + PAP_CONSISTENCY_CHECK + "\n";
  contents = contents + 'consistency_check.repair = ' + PAP_CONSISTENCY_CHECK_REPAIR + "\n";
  contents = contents + "\n";
  contents = contents + '[standalone-service]' + "\n";
  contents = contents + 'entity_id = ' + PAP_ENTITY_ID + "\n";
  contents = contents + 'hostname = ' + PAP_HOST + "\n";
  contents = contents + 'port = ' + to_string(PAP_PORT) + "\n";
  contents = contents + 'shutdown_port = ' + to_string(PAP_SHUTDOWN_PORT) + "\n";
  if (is_defined(PAP_SHUTDOWN_COMMAND)) {
   contents = contents + 'shutdown_command = ' + PAP_SHUTDOWN_COMMAND + "\n";
  };
  contents = contents + "\n";
  contents = contents + '[security]' + "\n";
  contents = contents + 'certificate = ' + SITE_DEF_HOST_CERT + "\n";
  contents = contents + 'private_key = ' + SITE_DEF_HOST_KEY + "\n";

  contents;
};

'/software/components/filecopy/services' =
  npush(escape(PAP_CONFIG_FILE),
        nlist('config', PAP_CONFIG_CONTENTS,
              'owner', 'root',
              'perms', '0640',
              'restart', '/sbin/service argus-pap restart',
       )
  );

include { 'components/metaconfig/config' };
#include { 'personality/argus/schema-pap' };

#bind '/software/components/metaconfig/services/{/etc/argus/pap/pap_configuration.ini}/contents' = pap_configuration;
prefix '/software/components/metaconfig/services/{/etc/argus/pap/pap_configuration.ini.metaconfig}';
'module'   = 'tiny';
'mode'     = 0644;
'owner'    = 'root';
'group'    = 'root';
'contents/paps' = {
  paps_config = nlist();
  ok = first(PAPS,name,properties);
  while (ok) {
    paps_config[name+".type"]     = properties['type'];
    paps_config[name+".enabled"]  = properties['enabled'];
    paps_config[name+".dn"]       = properties['dn'];
    paps_config[name+".hostname"] = properties['hostname'];
    paps_config[name+".port"]     = properties['port'];
    paps_config[name+".path"]     = properties['path'];
    paps_config[name+".protocol"] = properties['protocol'];
    paps_config[name+".public"]   = properties['public'];
    ok = next(PAPS,name,properties);
  };
  paps_config;
};

'contents/{paps:properties}/pool_interval' = PAP_POLL_INTERVAL;
'contents/{paps:properties}/ordering' = PAP_ORDERING;

'contents/repository/location'                 = PAP_REPO_LOCATION;
'contents/repository/consistency_check'        = PAP_CONSISTENCY_CHECK;
'contents/repository/consistency_check.repair' = PAP_CONSISTENCY_CHECK_REPAIR;

'contents/security/certificate'                = SITE_DEF_HOST_CERT;
'contents/security/private_key'                = SITE_DEF_HOST_KEY;

'contents/standalone-service/entity_id'        = PAP_ENTITY_ID;
'contents/standalone-service/hostname'         = PAP_HOST;
'contents/standalone-service/port'             = PAP_PORT;
'contents/standalone-service/shutdown_port'    = PAP_SHUTDOWN_PORT;
'contents/standalone-service' = {
  if (is_defined(PAP_SHUTDOWN_COMMAND)) {
    SELF['shutdown_command'] = PAP_SHUTDOWN_COMMAND;
  };
  SELF;
};

#-----------------------------------------------------------------------------
# PAP Authorization
#-----------------------------------------------------------------------------

variable PAP_AUTHZ_FILE = PAP_HOME + '/conf/pap_authorization.ini';
variable PAP_AUTHZ_CONTENTS = {
  contents = '#' + "\n";
  contents = contents + '# PAP service access control' + "\n";
  contents = contents + '# ' + "\n";
  contents = contents + '# Documentation: https://twiki.cern.ch/twiki/bin/view/EGEE/AuthZPAPConfig' + "\n";
  contents = contents + '# ' + "\n";
  contents = contents + '[dn]' + "\n";
  foreach (i;dn;PAP_ADMIN_DN) {
    contents = contents + '"' + dn + '" : ALL' + "\n";
  };
  contents = contents + '"' + PAP_HOST_DN + '" : ALL' + "\n";
  contents = contents + "\n";
  contents = contents + '[fqan]' + "\n";

  contents;
};

'/software/components/filecopy/services' =
  npush(escape(PAP_AUTHZ_FILE),
        nlist('config', PAP_AUTHZ_CONTENTS,
              'owner', 'root',
              'perms', '0640',
              'restart', '/sbin/service pap-standalone restart',
       )
  );


#-----------------------------------------------------------------------------
# PAP Admin Client Default Properties
#-----------------------------------------------------------------------------

variable PAP_ADMIN_PROPERTIES_FILE = PAP_HOME + '/conf/pap-admin.properties';
variable PAP_ADMIN_PROPERTIES_CONTENTS = {
  contents = '#' + "\n";
  contents = contents + '# PAP admin client default properties' + "\n";
  contents = contents + '# ' + "\n";
  contents = contents + '# Documentation: https://twiki.cern.ch/twiki/bin/view/EGEE/AuthZPAPConfig' + "\n";
  contents = contents + '# ' + "\n";
  contents = contents + 'host=' + PAP_HOST + "\n";
  contents = contents + 'port=' + to_string(PAP_PORT) + "\n";

  contents;
};

'/software/components/filecopy/services' =
  npush(escape(PAP_ADMIN_PROPERTIES_FILE),
        nlist('config', PAP_ADMIN_PROPERTIES_CONTENTS,
              'owner', 'root',
              'perms', '0644',
              'restart', '/sbin/service pap-standalone restart',
       )
  );


#-----------------------------------------------------------------------------
# Policy Generation Script
#-----------------------------------------------------------------------------

variable POLICY_SCRIPT_FILE ?= '/root/sbin/from-groupmap-to-policy.sh';

variable POLICY_SCRIPT_CONTENTS = {
  contents = <<EOF;
#!/bin/sh

# Use specified or default file as input
if [ "x$1" != "x" ]; then
    infile="$1"
else
    infile="GROUPMAPFILE"
fi

# Preface
echo 'resource "http://authz-interop.org/xacml/resource/resource-type/wn" {
    obligation "http://glite.org/xacml/obligation/local-environment-map" {}
    action "http://glite.org/xacml/action/execute" {
'

# Note: the order of '-e' clauses in the following sed is important!
# First: Permit any indicated group/role as pfqan
# Second: If some /vo/* rule exists, allow '/vo' as any fqan
#         (assuming '/vo' will always be in the proxy to achieve '*' behaviour)
# Third: Remove any other '*' rule, since the previous one should cover our '*' cases
sed -e 's@\("[^*]*"\).*@     rule permit {pfqan = \1 }@' \
    -e '/"\/[^/]*\/\*"/s@"\(/.*\)/.*@     rule permit {fqan = "\1" }@' \
    -e '/\*/d'  \
    $infile

# End the policy
echo "    }
}
"
EOF
  contents = replace('GROUPMAPFILE', LCMAPS_CONFIG_DIR + '/groupmapfile',contents);

  contents;
};

"/software/components/filecopy/services" =
  npush(escape(POLICY_SCRIPT_FILE),
        nlist("config",POLICY_SCRIPT_CONTENTS,
              "owner","root:root",
              "perms","0750",
       )
  );


#-----------------------------------------------------------------------------
# Fix temporary RPM issues
#-----------------------------------------------------------------------------

include { 'components/dirperm/config' };

'/software/components/dirperm/paths' = {
  SELF[length(SELF)] = nlist('path', PAP_LOCATION_SBIN,
                             'owner', 'root:root',
                             'perm', '0750',
                             'type', 'd',
                            );
  SELF[length(SELF)] = nlist('path', PAP_LOCATION_LOG,
                             'owner', 'root:root',
                             'perm', '0750',
                             'type', 'd',
                            );

  SELF;
};

