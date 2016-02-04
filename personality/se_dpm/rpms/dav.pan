unique template personality/se_dpm/rpms/dav;

'/software/packages' = {
  pkg_repl('lcgdm-dav-server');
  pkg_repl('lcgdm-dav-libs');
  pkg_repl('lcgdm-dav');
  pkg_repl('gridsite-libs');
  pkg_repl('gridsite-apache');
  
  pkg_repl('httpd');
  
  SELF['mod_dav_svn'] = null;
  SELF['mod_nss'] = null;
  SELF['mod_revocator'] = null;

  SELF;
};
