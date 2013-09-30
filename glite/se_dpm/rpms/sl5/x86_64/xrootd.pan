unique template glite/se_dpm/rpms/sl5/x86_64/xrootd;

variable DPM_XROOTD_PLUGIN_VERSION ?= '3.1.1-1.el5';

'/software/packages'=pkg_repl('dpm-xrootd',DPM_XROOTD_PLUGIN_VERSION,PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('dpm-xrootd-debuginfo',DPM_XROOTD_PLUGIN_VERSION,PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('dpm-xrootd-devel',DPM_XROOTD_PLUGIN_VERSION,PKG_ARCH_GLITE);

