unique template glite/bdii/rpms/sl6/x86_64/config;

# BDII specific RPMS

'/software/packages' = pkg_repl('bdii', '5.2.13-1.el6', 'noarch');
'/software/packages' = pkg_repl('glite-info-provider-ldap', '1.4.1-1.el6', 'noarch');
'/software/packages' = pkg_repl('glite-info-provider-service', '1.9.0-5.el6', 'noarch');
'/software/packages' = pkg_repl('glite-yaim-bdii', '4.3.11-1.el6', 'noarch');
'/software/packages' = pkg_repl('glite-yaim-core', '5.1.0-1.sl6', 'noarch');
'/software/packages' = pkg_repl('glue-schema', '2.0.8-2.el6', 'noarch');

'/software/packages' = {
    if (BDII_TYPE == 'site' || BDII_TYPE == 'combined') {
        pkg_repl('bdii', '5.2.12-1.el6', 'noarch'); # Override EPEL version already installed on some resources
        pkg_repl('bdii-config-site', '1.0.6-1.el6', 'noarch');
        pkg_repl('emi-bdii-site', '1.0.0-1.sl6', 'x86_64');
        pkg_repl('glite-info-site', '0.4.0-1.el6', 'noarch');
        pkg_repl('glite-info-static', '0.2.0-1.el6', 'noarch');
        pkg_repl('emi-version', '2.4.0-1.sl6', 'x86_64');
    };
    if (BDII_TYPE == 'top') {
        pkg_repl('bdii', '5.2.12-1.el6', 'noarch'); # Override EPEL version already installed on some resources
        pkg_repl('bdii-config-top', '1.0.6-1.el6', 'noarch');
        pkg_repl('emi-bdii-top', '1.0.1-2.sl6', 'x86_64');
        pkg_repl('glite-info-plugin-fcr', '3.0.4-1', 'noarch');
        pkg_repl('glite-info-update-endpoints', '2.0.10-1', 'noarch');
        pkg_repl('emi-resource-information-service', '1.0.3-1.sl6', 'x86_64');
        pkg_repl('emi-version', '2.4.0-1.sl6', 'x86_64');
        pkg_repl('glue-validator', '1.0.2-3.el6', 'noarch');
        pkg_repl('glue-validator-cron', '1.0.1-1.el6', 'noarch');
    };
    SELF;
};
