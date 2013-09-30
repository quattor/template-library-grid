unique template common/fts/client/config;

variable GLITE_LOCATION ?= "/opt/glite";

# FIXME: This is currently a hardcoded configuration.  This should
# be taken over by the gLite configuration component.

# ---------------------------------------------------------------------------- 
# filecopy
# ---------------------------------------------------------------------------- 
include { 'components/filecopy/config' };

variable FTS_SERVER_PORT ?= 8443;
variable FTS_SERVER_TRANSFER_SERVICE_PATH ?= '/glite-data-transfer-fts';

variable FTS_SERVICES_PARAMS = nlist(
  'EGEEfts',              nlist('endpoint','FileTransfer',
                                'type','org.glite.FileTransfer',
                                'version', '3.3.0',
                               ),
  'EGEEchannel',          nlist('endpoint','ChannelManagement',
                                'type','org.glite.ChannelManagement',
                                'version', '3.3.0',
                               ),
  'EGEEdelegation',       nlist('endpoint','gridsite-delegation',
                                'type','org.glite.Delegation',
                                'version', '3.3.0',
                               ),
);

# Build FTS_SERVER_URL if not explicitly specified
variable FTS_SERVER_URL ?= {
  if ( exists(FTS_SERVER_HOST) && is_defined(FTS_SERVER_HOST) ) {
    url = 'https://' + FTS_SERVER_HOST + ':' + to_string(FTS_SERVER_PORT) + FTS_SERVER_TRANSFER_SERVICE_PATH;
  } else {
    url = undef
  };
  
  url;
};

# Build services.xml configuration file

variable CONTENTS = {
  contents = '';
  
  contents = <<EOF;
<?xml version="1.0" encoding="UTF-8"?>

<services>

EOF

  if ( exists(FTS_SERVER_URL) && is_defined(FTS_SERVER_URL) ) {
    foreach (service;params;FTS_SERVICES_PARAMS) {
      contents = contents + "  <service name='"+service+"'>\n";
      contents = contents + "    <parameters>\n";
      contents = contents + "      <endpoint>"+FTS_SERVER_URL+"/services/"+params['endpoint']+"</endpoint>\n";
      contents = contents + "      <type>"+params['type']+"</type>\n";
      contents = contents + "      <version>"+params['version']+"</version>\n";
      contents = contents + "    </parameters>\n";
      contents = contents + "  </service>\n\n";
    };
  };

contents = contents + <<EOF;

</services>
EOF
  
  contents;
};


# Add this file to the configuration. 
"/software/components/filecopy/services" =
  npush(escape(GLITE_LOCATION+"/etc/services.xml"),
        nlist("config",CONTENTS,
              "perms","0755"));

