unique template glite/xrootd/env;

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
