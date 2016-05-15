unique template personality/xrootd/env;

variable XROOTD_INSTALL_ROOT ?= INSTALL_ROOT;
variable XROOTD_INSTALL_ETC ?= XROOTD_INSTALL_ROOT + '/etc';
variable XROOTD_INSTALL_LOG ?= '/var/log/xrootd';
variable XROOTD_HOST_CERT_DIR ?= SITE_DEF_GRIDSEC_ROOT + '/' + DPM_USER;
variable XROOTD_AUTH_TOKEN_CONF_DIR ?= SITE_DEF_GRIDSEC_ROOT + '/xrootd';
variable XROOTD_CONFIG_DIR ?= XROOTD_INSTALL_ETC + '/xrootd';
variable XROOTD_LOG_FILE ?= XROOTD_INSTALL_LOG+'/xrootd.log';
variable XROOTD_SPOOL_DIR ?= XROOTD_INSTALL_ROOT + '/var/spool/xrootd';
variable XROOTD_MAIN_SERVICE ?= 'xrootd';
variable XROOTD_CMSD_SERVICE ?= 'cmsd';
variable XROOTD_QUATTOR_TEMPL_EXT ?= '.templ-quattor';

# Define is vomsxrd plugin is used to access VOM information when GSI is enabled
variable VOMS_XROOTD_EXTENSION_ENABLED ?= true;

# Default Xrootd site name built from GRIF site name
variable XROOTD_SITE_NAME ?= {
  if ( !is_defined(SITE_NAME) ) {
    error('SITE_NAME undefined: cannot guess Xrootd site name');
  };
  site_name = SITE_NAME;
  if ( is_defined(BDII_SUBSITE) ) {
    site_name = site_name + '-' + BDII_SUBSITE;
  };
  site_name;
};

# Default monitoring options to use if none are defined in the federation parameters or if
# there are several federations configured with monitoring enabled.
variable XROOTD_MONITORING_OPTIONS ?= 'all flush io 30s ident 5m fstat 60 lfn ops xfr 5 mbuff 8k rbuff 4k rnums 3 window 5s';
# Other default values for monitoring and reporting
variable XROOTD_MONITORING_EVENTS ?= list('files','io','info','user','redir'); 
variable XROOTD_REPORTING_OPTIONS ?= 'every 60s all -buff -poll sync';
# Monitoring destinations: both must be lists
variable XROOTD_MONITORING_DESTINATIONS ?= undef;
variable XROOTD_REPORTING_DESTINATIONS ?= undef;


# Default GSI-related parameters
variable XROOTD_SECURITY_GSI_PARAMS ?= {
  SELF["ca"] = 2;
  SELF["cert"] = "/etc/grid-security/dpmmgr/dpmcert.pem";
  SELF["crl"] = 3;
  SELF["gmapopt"] = 10;
  SELF["key"] = "/etc/grid-security/dpmmgr/dpmkey.pem";
  SELF["md"] = "sha256:sha1";
  if ( VOMS_XROOTD_EXTENSION_ENABLED ) { 
    SELF["vomsfun"] = "/usr/lib64/libXrdSecgsiVOMS.so";
  } else {
    SELF["vomsat"] = 0;
  };

  SELF;
};
