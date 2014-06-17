unique template features/gip/se;

# List of VOs to configure for DPM
variable SEDPM_VOS ?= VOS;

# File containing DPM DB connection information for GIP.
# This default value must match default value computed by dpmlfc component.
variable SEDPM_INFO_CONFIG ?= GLITE_LOCATION + '/etc/DPMINFO';

# Default ports.
variable GSIFTP_PORT ?= 2811;
variable DCAP_PORT ?= 22128;
variable RFIO_PORT ?= 5001;
variable SRMV1_PORT ?= 8443;
variable SRMV2_PORT ?= 8444;
variable SRMV2_2_PORT ?= 8446;

# All protocols off by default.
variable GSIFTP_ENABLED ?= false;
variable DCAP_ENABLED ?= false;
variable RFIO_ENABLED ?= false;
variable SRMV1_ENABLED ?= false;
variable SRMV2_ENABLED ?= false;
variable XROOTD_ENABLED ?= false;

# SE Implementation friendly name
variable GIP_SE_IMPL_NAME ?= nlist(
  'SE_castor',  'CASTOR',
  'SE_classic', 'Classic SE',
  'SE_dcache',  'dCache',
  'SE_dpm',     'DPM',
);

# Service parameters for each SRM version
variable GIP_SE_SRM_PARAMS = nlist(
  escape('1.1.0'),    nlist(
                            'active', SRMV1_ENABLED,
                            'endpoint', '/srm/managerv1',
                            'port', SRMV1_PORT,
                            'serviceType', 'SRM',
                           ),
  escape('2.2.0'),    nlist(
                            'active', SRMV2_ENABLED,
                            'endpoint', '/srm/managerv2',
                            'port', SRMV2_2_PORT,
                            'serviceType', 'SRM',
                           ),
);

# GIP provider scripts and other related files

# The value of GIP_PROVIDER_SERVICE_CONF_BASE is used as the base file name for the config file.
# SRM version and .conf will be appended.
variable GIP_PROVIDER_SERVICE_CONF_BASE ?= GIP_SCRIPTS_CONF_DIR + '/glite-info-service-srm';
variable GIP_PROVIDER_SUBSERVICE ?= nlist(
  'SE_castor',         GIP_SCRIPTS_DIR + '/glite-info-service-castor',
  'SE_dcache',         GIP_SCRIPTS_DIR + '/glite-info-service-dcache',
  'SE_dpm',            GIP_SCRIPTS_DIR + '/glite-info-service-dpm',
  'service_test',      GIP_SCRIPTS_DIR + '/glite-info-service-test',
);
variable GIP_STATIC_SE_BASE ?= 'glite-info-static-se';
variable GIP_STATIC_SE_TEMPLATE ?= GIP_GLUE_TEMPLATES_DIR + '/GlueSE.template';
variable GIP_PROVIDER_DPM_LOCATION ?= '/usr/bin/dpm-listspaces';
variable GIP_PROVIDER_SRM ?= nlist(
  'SE_castor',         undef,
  'SE_dcache',         undef,
  'SE_dpm',            'export X509_USER_PROXY='+DPM_HOSTPROXY_FILE+"\n"+
                           GIP_PROVIDER_DPM_LOCATION + ' --gip --glue2 --protocols --site ' + SITE_NAME,
);
# This variable allows to install a non standard version of the provider.
# Its value must be a template doing what is necessary to install it.
# undef or null value causes nothing to be installed : in this case provider listed in GIP_PROVIDER_SRM
# must be already present on the SE.
variable GIP_PROVIDER_SRM_CONFIG ?= nlist(
  'SE_castor',         undef,
  'SE_dcache',         undef,
  # Distributed as part of gridpp-dpm-tools
  #'SE_dpm',            'features/gip/dpm-listspaces',
  'SE_dpm',            undef,
);

# Need the full VO names for access control.
variable SEDPM_VOS ?= VOS;
variable GIP_SE_VOS_FULL = {
  result = list();
  vos = SEDPM_VOS;
  ok = first(vos,k,v);
  while (ok) {
    result[length(result)] = VO_INFO[v]['name'];
    ok = next(vos,k,v);
  };
  result;
};


# Configure GIP provider for services

"/software/components/gip2" = {
  se_type = SE_HOSTS[FULL_HOSTNAME]['type'];
  if ( !match(se_type,'SE_dcache|SE_dpm') ) {
    error("SE type '"+se_type+" not yet supported");
  };

  foreach (version_e;params;GIP_SE_SRM_PARAMS) {
    version = unescape(version_e);
    if ( params['active'] ) {
      if ( !exists(SELF['provider']) ) {
        SELF['provider'] = nlist();
      };
      if ( !exists(SELF['confFiles']) ) {
        SELF['confFiles'] = nlist();
      };
      unique_id = 'httpg://'+FULL_HOSTNAME+':'+to_string(params['port'])+params['endpoint'];
      if ( version == '1.1.0' ) {
        srm_major = '1';
        srm_minor = '.1';
      } else {
        srm_major = '2';
        srm_minor = '.2';
      };
      provider_conf_file = GIP_PROVIDER_SERVICE_CONF_BASE + '-' + srm_major + srm_minor + '.conf';
      # To help identifying SE per subsite, e.g. for FTS channel configuration       
      if ( exists(BDII_SUBSITE) &&
           is_defined(BDII_SUBSITE) &&
           (length(BDII_SUBSITE) > 0) ) {
        service_data = "SubSite="+SITE_NAME+'-'+BDII_SUBSITE+"\n";
      } else {
        service_data = '';
      };
      service_owner_cmd = '';
      service_acbr_cmd = '';
      foreach (i;vo;GIP_SE_VOS_FULL) {
        service_owner_cmd = service_owner_cmd + ' echo ' + vo + ';';
        service_acbr_cmd = service_acbr_cmd + ' echo VO:' + vo + ';';
      };
      
      SELF['confFiles'][escape(provider_conf_file)] = "init = "+GIP_PROVIDER_SUBSERVICE[se_type]+" init v"+to_string(srm_major)+"\n" +
                                                      "service_type = "+params['serviceType']+"\n" +
                                                      "get_version = echo $GLITE_INFO_SERVICE_VERSION\n" +
                                                      "get_endpoint = echo $GLITE_INFO_SERVICE_ENDPOINT\n" +
                                                      "get_status = "+GIP_PROVIDER_SUBSERVICE['service_test']+" SRM_V"+srm_major+" && "+
                                                                                          GIP_PROVIDER_SUBSERVICE[se_type]+" status v"+srm_major+"\n" +
                                                      "WSDL_URL = http://sdm.lbl.gov/srm-wg/srm.v"+srm_major+srm_minor+".wsdl\n" +
                                                      "semantics_URL = http://sdm.lbl.gov/srm-wg/doc/SRM.v"+srm_major+srm_minor+".html\n" +
                                                      "get_starttime = perl -e '@st=stat(\"/var/run/dpm.pid\");print \"@st[10]\\n\";'\n" +
                                                      "get_owner = "+service_owner_cmd+"\n" +
                                                      "get_acbr = "+service_acbr_cmd+"\n" +
                                                      "get_data = echo "+service_data+"\n" +
                                                      "get_services = echo\n";
      SELF['provider']['glite-info-service-srm' + '-' + srm_major + srm_minor] =
        "#!/bin/sh\n" + 
        "# Ensure provider is using the right name for DPM head node\n" +
        "export DPM_HOST=" + FULL_HOSTNAME + "\n" +
            GIP_PROVIDER_SERVICE + ' ' + provider_conf_file + ' ' + SITE_NAME + ' ' + unique_id + "\n";

      # Glue v2
      SELF['provider']['glite-info-service-srm' + '-' + srm_major + srm_minor + '-glue2'] =
          "#!/bin/sh\n" + 
          "# Ensure provider is using the right name for DPM head node\n" +
          "export DPM_HOST=" + FULL_HOSTNAME + "\n" +
              GIP_PROVIDER_SERVICE + '-glue2 ' + provider_conf_file + ' ' + SITE_NAME + ' ' + unique_id + "\n";
    };
  };
  
  if ( is_defined(SELF) ) {
    SELF;
  } else {
    null;
  };
};


# Static SE information.
"/software/components/gip2/ldif" = {
  if (exists(SELF) && is_defined(SELF) && !is_nlist(SELF)) {
    error('/software/components/gip2/ldif must be an nlist');
  };

  # GIP provider for DPM handles this.
  if ( match(SE_HOSTS[FULL_HOSTNAME]['type'],'SE_dpm') ) {
    if ( is_defined(SELF) ) {
      return(SELF);
    } else {
      return(null);
    };
  };

  entries = nlist();

  endpoint = 'httpg://'+FULL_HOSTNAME+':'+to_string(SRMV1_PORT)+'/srm/managerv1';
  protocol = 'srm_v1';
  se_type = 'srm_v1';
  if ( exists(SE_HOSTS[FULL_HOSTNAME]['arch']) && is_defined(SE_HOSTS[FULL_HOSTNAME]['arch']) ) {
    se_arch = SE_HOSTS[FULL_HOSTNAME]['arch'];
  } else {
    se_arch = 'multidisk';
  };

  entries[escape('dn: GlueSEUniqueID='+FULL_HOSTNAME)] = 
    nlist(
         'GlueSEName',                  list(SITE_NAME+':'+se_type),
         'GlueSEPort',                  list(to_string(GSIFTP_PORT)),
         'GlueSESizeTotal',             list('0'),
         'GlueSESizeFree',              list('0'),
         'GlueSEArchitecture',          list(se_arch),
         'GlueSEImplementationName',    list(GIP_SE_IMPL_NAME[SE_HOSTS[FULL_HOSTNAME]['type']]),
         'GlueSEImplementationVersion', list('not set'),
         'GlueSEStatus',                list('Production'),
         'GlueSETotalOnlineSize',       list('0'),
         'GlueSETotalNearlineSize',     list('0'),
         'GlueSEUsedOnlineSize',        list('0'),
         'GlueSEUsedNearlineSize',      list('0'),
         'GlueInformationServiceURL',   list(RESOURCE_INFORMATION_URL),
         'GlueForeignKey',              list('GlueSiteUniqueID='+SITE_NAME),
         );

  if (GSIFTP_ENABLED) {
    entries[escape('dn: GlueSEAccessProtocolLocalID=gsiftp, GlueSEUniqueID='+FULL_HOSTNAME)] = 
      nlist(
           'GlueSEAccessProtocolType',              list('gsiftp'),
           'GlueSEAccessProtocolEndpoint',          list('gsiftp://'+FULL_HOSTNAME+':'+to_string(GSIFTP_PORT)),
           'GlueSEAccessProtocolCapability',        list('file transfer'),
           'GlueSEAccessProtocolVersion',           list('1.0.0'),
           'GlueSEAccessProtocolPort',              list(to_string(GSIFTP_PORT)), 
           'GlueSEAccessProtocolSupportedSecurity', list('GSI'),
           'GlueSEAccessProtocolMaxStreams',        list('999'),
           'GlueChunkKey',                          list('GlueSEUniqueID='+FULL_HOSTNAME),
           );
  };

  if (DCAP_ENABLED) {
    entries[escape('dn: GlueSEAccessProtocolLocalID=gsidcap, GlueSEUniqueID='+FULL_HOSTNAME)] = 
      nlist(
           'GlueSEAccessProtocolType',              list('gsidcap'),
           'GlueSEAccessProtocolEndpoint',          list(endpoint),
           'GlueSEAccessProtocolCapability',        list('byte access'),
           'GlueSEAccessProtocolVersion',           list('1.0.0'),
           'GlueSEAccessProtocolPort',              list(to_string(DCAP_PORT)), 
           'GlueSEAccessProtocolSupportedSecurity', list('GSIDCAP'),
           'GlueSEAccessProtocolMaxStreams',        list('999'),
           'GlueChunkKey',                          list('GlueSEUniqueID='+FULL_HOSTNAME),
           );
  };

  if (RFIO_ENABLED) {
    entries[escape('dn: GlueSEAccessProtocolLocalID=rfio, GlueSEUniqueID='+FULL_HOSTNAME)] = 
      nlist(
           'GlueSEAccessProtocolType',              list('rfio'),
           'GlueSEAccessProtocolEndpoint',          list(endpoint),
           'GlueSEAccessProtocolCapability',        list('byte access'),
           'GlueSEAccessProtocolVersion',           list('1.0.0'),
           'GlueSEAccessProtocolPort',              list(to_string(RFIO_PORT)), 
           'GlueSEAccessProtocolSupportedSecurity', list('RFIO'),
           'GlueSEAccessProtocolMaxStreams',        list('999'),
           'GlueChunkKey',                          list('GlueSEUniqueID='+FULL_HOSTNAME),
           );
  };

  entries[escape('dn: GlueSEControlProtocolLocalID='+protocol+', GlueSEUniqueID='+FULL_HOSTNAME)] = 
    nlist(
         'GlueSEControlProtocolType',             list(protocol),
         'GlueSEControlProtocolEndpoint',         list(endpoint),
         'GlueSEControlProtocolCapability',       list('control'),
         'GlueSEControlProtocolVersion',          list('1.0.0'),
         'GlueSEAccessProtocolMaxStreams',        list('999'),
         'GlueChunkKey',                          list('GlueSEUniqueID='+FULL_HOSTNAME),
         );

  ldif_conf_file = GIP_STATIC_SE_BASE + '.conf';
  SELF[ldif_conf_file] = nlist();
  SELF[ldif_conf_file]['template'] = GIP_STATIC_SE_TEMPLATE;
  SELF[ldif_conf_file]['entries'] = entries;
  SELF[ldif_conf_file]['ldifFile'] = GIP_STATIC_SE_BASE + '.ldif';
  SELF;
};


# Configure provider for SE dynamic information.
# Install it if necessary.
variable GIP_DYNAMIC_SE_PROVIDER_TEMPLATE = GIP_PROVIDER_SRM_CONFIG[SE_HOSTS[FULL_HOSTNAME]['type']];
include { GIP_DYNAMIC_SE_PROVIDER_TEMPLATE };
'/software/components/gip2/provider' = {
  if (exists(SELF) && is_defined(SELF) && !is_nlist(SELF)) {
    error('/software/components/gip2/provider must be an nlist');
  };

  if ( SE_HOSTS[FULL_HOSTNAME]['type'] == 'SE_dpm' ) {
    provider_name = 'glite-info-dynamic-dpm';
    wrapper = "#!/bin/sh\n" +
              GIP_PROVIDER_SRM[SE_HOSTS[FULL_HOSTNAME]['type']] + "\n";
  } else {
    # FIXME : add support for dCache with new provider
    return(SELF);
  };
  SELF[provider_name] = wrapper;

  SELF;
};
