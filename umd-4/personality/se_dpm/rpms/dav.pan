unique template personality/se_dpm/rpms/dav;

'/software/packages' = {
    if (pkg_compare_version(DPM_VERSION, '1.13.0') == PKG_VERSION_LESS) {
        pkg_repl('lcgdm-dav-server');
        pkg_repl('lcgdm-dav-libs');
        pkg_repl('lcgdm-dav');
        pkg_repl('gridsite-libs');
        pkg_repl('gridsite-apache');
        pkg_repl('httpd');
    } else {
        pkg_repl('dmlite-apache-httpd');
    };

    SELF['mod_dav_svn'] = null;
    SELF['mod_nss'] = null;
    SELF['mod_revocator'] = null;

    SELF;
};
