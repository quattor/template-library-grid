# This template has been generated from official gLite 3.1 list for 32-bit

unique template glite/se_dpm/rpms/sl5/x86_64/base;

include { 'glite/se_dpm/variables' };

# RPMS provided by OS
include { OS_NS_CONFIG_EMI + 'dpmlfc-common' };

"/software/packages"=pkg_repl('dpm',        DPM_VERSION,        PKG_ARCH_GLITE);
"/software/packages"=pkg_repl('dpm-devel',  DPM_DEVEL_VERSION,  PKG_ARCH_GLITE);
"/software/packages"=pkg_repl('dpm-libs',   DPM_LIBS_VERSION,   PKG_ARCH_GLITE);
"/software/packages"=pkg_repl('lcgdm-devel',LCGDM_DEVEL_VERSION,PKG_ARCH_GLITE);
"/software/packages"=pkg_repl('lcgdm-libs', LCGDM_LIBS_VERSION, PKG_ARCH_GLITE);
"/software/packages"=pkg_repl("dpm-perl",   DPM_PERL_VERSION,   PKG_ARCH_GLITE);
"/software/packages"=pkg_repl('dpm-python', DPM_PYTHON_VERSION, PKG_ARCH_GLITE);
"/software/packages"=pkg_repl('dpm-dsi',    DPM_DSI_VERSION,    PKG_ARCH_GLITE);

'/software/packages'=pkg_repl('dpm-yaim', '4.2.7-1.el5', 'noarch');
"/software/packages"=pkg_repl("emi-version","2.3.0-1.sl5",PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('glite-yaim-core',"5.1.0-1.sl5", 'noarch');
'/software/packages'=pkg_repl('glite-yaim-bdii', "4.3.11-1.el5", 'noarch');
"/software/packages"=pkg_repl("glue-schema","2.0.8-2.el5","noarch");
"/software/packages"=pkg_repl("lcg-expiregridmapdir","3.0.1-1","noarch");
"/software/packages"=pkg_repl("voms","2.0.8-1.el5","x86_64");
"/software/packages"=pkg_repl("voms-devel","2.0.8-1.el5",PKG_ARCH_GLITE);
"/software/packages"=pkg_repl('CGSI-gSOAP','1.3.5-2.el5','x86_64');

# Update 08

'/software/packages' = {
  if ( EMI_UPDATE_VERSION >= '08' ) {
    # From EPEL
    pkg_repl("python-lxml","2.0.11-1.el5","x86_64");
    pkg_repl("python-uuid","1.30-3.el5","noarch");
  };
  SELF;
};

