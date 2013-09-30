# This template is based on official RPM list for DPM MySQL as provided by gLite
# All RPMs already part of base.tpl have been removed

unique template glite/se_dpm/rpms/sl5/x86_64/mysql;

include { 'glite/se_dpm/variables' };

'/software/packages' = pkg_repl("dpm-copy-server-mysql",DPM_COPY_SERVER_VERSION, "x86_64");
'/software/packages' = pkg_repl("dpm-name-server-mysql",DPM_NAME_SERVER_VERSION, "x86_64");
'/software/packages' = pkg_repl("dpm-server-mysql",     DPM_SERVER_MYSQL_VERSION,"x86_64");
'/software/packages' = pkg_repl("dpm-srm-server-mysql", DPM_SRM_VERSION,         "x86_64");
'/software/packages' = pkg_repl("dpm-rfio-server",      DPM_RFIO_VERSION,        "x86_64");

'/software/packages' = pkg_repl('gsoap',                '2.7.13-3.el5',   PKG_ARCH_GLITE);

