# This template has been generated from official gLite 3.1 list for 32-bit

unique template glite/se_dpm/rpms/sl6/x86_64/base;

include { 'glite/se_dpm/variables' };

# RPMS provided by OS
include { OS_NS_CONFIG_EMI + 'dpmlfc-common' };

# RPMs required by both emi-dpm_disk and emi-dpm_mysql
# EMI
'/software/packages'=pkg_repl('canl-c','2.0.9-1.el6','x86_64');
'/software/packages'=pkg_repl('dpm',        DPM_VERSION,        PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('dpm-devel',  DPM_DEVEL_VERSION,  PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('dpm-libs',   DPM_LIBS_VERSION,   PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('dpm-perl',   DPM_PERL_VERSION,   PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('dpm-python', DPM_PYTHON_VERSION, PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('dpm-yaim','4.2.9-1.el6','noarch');
'/software/packages'=pkg_repl('emi-version','3.0.0-1.sl6','x86_64');
'/software/packages'=pkg_repl('glite-yaim-core','5.1.1-1.sl6','noarch');
'/software/packages'=pkg_repl('glite-yaim-bdii','4.3.13-1.el6','noarch');
'/software/packages'=pkg_repl('glue-schema','2.0.10-1.el6','noarch');
'/software/packages'=pkg_repl('gridsite','2.0.4-1.el6','x86_64');
'/software/packages'=pkg_repl('gridsite-libs','2.0.4-1.el6','x86_64');
'/software/packages'=pkg_repl('lcg-expiregridmapdir','3.0.1-1','noarch');
'/software/packages'=pkg_repl('lcgdm-devel',LCGDM_DEVEL_VERSION,PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('lcgdm-libs', LCGDM_LIBS_VERSION, PKG_ARCH_GLITE);
'/software/packages'=pkg_repl('voms','2.0.10-1.el6','x86_64');
'/software/packages'=pkg_repl('voms-devel','2.0.10-1.el6','x86_64');

# EPEL
'/software/packages'=pkg_repl('dpm-dsi','1.8.3-1.el6','x86_64');
'/software/packages'=pkg_repl('dmlite-libs','0.4.2-2.el6','x86_64');
'/software/packages'=pkg_repl('dmlite-plugins-adapter','0.4.0-2.el6','x86_64');
'/software/packages'=pkg_repl('dmlite-plugins-mysql','0.4.1-1.el6','x86_64');
'/software/packages'=pkg_repl('gsoap','2.7.16-3.el6','x86_64');
'/software/packages'=pkg_repl('json-c','0.10-2.el6','x86_64');
'/software/packages'=pkg_repl('lcgdm-dav','0.11.0-1.el6','x86_64');
'/software/packages'=pkg_repl('lcgdm-dav-libs','0.11.0-1.el6','x86_64');
'/software/packages'=pkg_repl('lcgdm-dav-server','0.11.0-1.el6','x86_64');
'/software/packages'=pkg_repl('gridsite-compat1.7','1.7.25-1.el6','x86_64');
