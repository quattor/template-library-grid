unique template glite/bdii/rpms/sl6/x86_64/config;

# BDII specific RPMS

'/software/packages' = pkg_repl('bdii', '5.2.17-1.el5', 'noarch');
'/software/packages' = pkg_repl('glite-info-provider-ldap', '1.4.4-1.el5', 'noarch');
'/software/packages' = pkg_repl('glite-info-provider-service', '1.12.0-1.el5', 'noarch');
'/software/packages' = pkg_repl('glite-yaim-bdii', '4.3.13-1.el5', 'noarch');
'/software/packages' = pkg_repl('glite-yaim-core', '5.1.1-1.sl5', 'noarch');
'/software/packages' = pkg_repl('glue-schema', '2.0.10-1.el5', 'noarch');

'/software/packages' = {
    if (BDII_TYPE == 'top' || BDII_TYPE == 'site' || BDII_TYPE == 'combined') {
        pkg_repl('bdii', '5.2.12-1.el6', 'noarch');
        pkg_repl('emi-resource-information-service', '1.0.3-1.el6', 'noarch');
        pkg_repl('emi-version', '3.0.0-1.sl5', 'x86_64');
        pkg_repl('glue-validator', '1.0.5-1.el5', 'noarch');
        pkg_repl('glue-validator-cron', '1.0.2-1.el5', 'noarch');
    };
    if (BDII_TYPE == 'site' || BDII_TYPE == 'combined') {
        pkg_repl('bdii-config-site', '1.0.7-1.el5', 'noarch');
        pkg_repl('emi-bdii-site', '1.0.0-1.el6', 'noarch');
        pkg_repl('glite-info-site', '0.4.0-1.el6', 'noarch');
        pkg_repl('glite-info-static', '0.2.0-1.el6', 'noarch');
    };
    if (BDII_TYPE == 'top') {
        pkg_repl('bdii-config-top', '1.0.7-1.el5', 'noarch');
        pkg_repl('emi-bdii-top', '1.0.1-2.el6', 'noarch');
        pkg_repl('glite-info-plugin-fcr', '3.0.5-1.el5', 'noarch');
        pkg_repl('glite-info-update-endpoints', '2.0.12-1.el5', 'noarch');
    };
    SELF;
};
