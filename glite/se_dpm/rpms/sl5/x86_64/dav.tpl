unique template glite/se_dpm/rpms/sl5/x86_64/dav;

'/software/packages'= {
  pkg_repl('json-c',          '0.9-1.el5',   'x86_64');
  pkg_repl('lcgdm-dav-server','0.8.0-1.el5', 'x86_64');
  pkg_repl('lcgdm-dav-libs',  '0.8.0-1.el5', 'x86_64');
  pkg_repl('lcgdm-dav',       '0.8.0-1.el5', 'x86_64');
  pkg_repl('gridsite-libs',   '1.7.21-2.el5','x86_64');
  pkg_repl('gridsite-apache', '1.7.21-2.el5','x86_64');
  pkg_repl('gsoap',           '2.7.13-3.el5','x86_64');
};

'/software/packages'=if ( EMI_UPDATE_VERSION >= '08' ) {
  # Some RPMs need to be deleted
  pkg_del('gridsite-apache');

  # Some RPMs need to be installed
  pkg_repl('dmlite-libs',  '0.4.2-1.el5','x86_64');
  pkg_repl('gridsite',     '1.7.25-1.emi2.el5','x86_64');
  pkg_repl('gridsite-libs','1.7.25-1.emi2.el5','x86_64');
  pkg_repl('dmlite-plugins-adapter','0.4.0-1.el5','x86_64');
} else {
  SELF;
};
