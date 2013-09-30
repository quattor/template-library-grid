unique template glite/argus/rpms/x86_64/config;

# -------------------------------------------------------
# Packages from EMI repository
# -------------------------------------------------------

# ARGUS - EMI
#'/software/packages' = pkg_repl('argus-gsi-pep-callout','1.2.2-1.sl5','x86_64');
'/software/packages' = pkg_repl('argus-pap','1.5.1-1.el5','noarch');
'/software/packages' = pkg_repl('argus-pdp','1.5.1-2.sl5','noarch');
'/software/packages' = pkg_repl('argus-pdp-pep-common','1.3.1-1.sl5','noarch');
'/software/packages' = pkg_repl('argus-pep-api-c','2.1.0-3.sl5','x86_64');
#'/software/packages' = pkg_repl('argus-pep-api-c-devel','2.1.0-3.sl5','x86_64');
'/software/packages' = pkg_repl('argus-pep-api-java','2.1.0-1.sl5','noarch');
'/software/packages' = pkg_repl('argus-pep-common','2.2.0-1.sl5','noarch');
'/software/packages' = pkg_repl('argus-pep-server','1.5.1-2.sl5','noarch');
'/software/packages' = pkg_repl('argus-pepcli','2.1.0-2.sl5','x86_64');
'/software/packages' = pkg_repl('emi-argus','1.5.0-1.sl5','x86_64');
'/software/packages' = pkg_repl('emi-trustmanager','3.1.4-1.sl5','noarch');
'/software/packages' = pkg_repl('emi-trustmanager-axis','2.0.2-1.sl5','noarch');
'/software/packages' = pkg_repl('emi-version','2.3.0-1.sl5','x86_64');

# BDII - ARGUS
'/software/packages' = pkg_repl('bdii','5.2.12-1.el5','noarch');
'/software/packages' = pkg_repl('glue-schema','2.0.8-2.el5','noarch');

# GLITE - EMI
'/software/packages' = pkg_repl('glite-info-provider-service','1.9.0-5.el5','noarch');
'/software/packages' = pkg_repl('glite-yaim-bdii','4.3.11-1.el5','noarch');
'/software/packages' = pkg_repl('glite-yaim-core','5.1.0-1.sl5','noarch');

# VOMS
'/software/packages' = pkg_repl('voms-api-java','2.0.8-1.el5','noarch');

# LCG
"/software/packages" = pkg_repl('lcg-expiregridmapdir','3.0.1-1','noarch');

# OTHER
'/software/packages' = pkg_repl('nagios-plugins-argus','1.0.0-1.sl5','noarch');
'/software/packages' = pkg_repl('yaim-argus_server','1.5.1-1.sl5','noarch');
