unique template glite/argus/rpms/x86_64/config;

# -------------------------------------------------------
# Packages from EMI repository
# -------------------------------------------------------

# ARGUS - EMI
#'/software/packages' = pkg_repl('argus-gsi-pep-callout','1.3.0-1.el5','x86_64');
'/software/packages' = pkg_repl('argus-pap','1.6.0-1.el5','noarch');
'/software/packages' = pkg_repl('argus-pdp','1.6.0-1.el5','noarch');
'/software/packages' = pkg_repl('argus-pdp-pep-common','1.4.0-2.el5','noarch');
'/software/packages' = pkg_repl('argus-pep-api-c','2.2.0-1.el5','x86_64');
#'/software/packages' = pkg_repl('argus-pep-api-c-devel','2.2.0-1.el5','x86_64');
'/software/packages' = pkg_repl('argus-pep-api-java','2.2.0-1.el5','noarch');
'/software/packages' = pkg_repl('argus-pep-common','2.3.0-1.el5','noarch');
'/software/packages' = pkg_repl('argus-pep-server','1.6.0-3.el5','noarch');
'/software/packages' = pkg_repl('argus-pepcli','2.2.0-1.el5','x86_64');
'/software/packages' = pkg_repl('emi-argus','1.5.0-1.sl5','x86_64');
'/software/packages' = pkg_repl('emi-trustmanager','3.1.4-1.sl5','noarch');
'/software/packages' = pkg_repl('emi-trustmanager-axis','2.0.2-1.sl5','noarch');
'/software/packages' = pkg_repl('emi-version','3.0.0-1.sl5','x86_64');

# BDII - ARGUS
'/software/packages' = pkg_repl('bdii','5.2.17-1.el5','noarch');
'/software/packages' = pkg_repl('glue-schema','2.0.10-1.el5','noarch');

# GLITE - EMI
'/software/packages' = pkg_repl('glite-info-provider-service','1.12.0-1.el5','noarch');
'/software/packages' = pkg_repl('glite-yaim-bdii','4.3.13-1.el5','noarch');
'/software/packages' = pkg_repl('glite-yaim-core','5.1.1-1.sl5','noarch');

# VOMS
'/software/packages' = pkg_repl('voms-api-java','2.0.10-1.el5','noarch');

# LCG
"/software/packages" = pkg_repl('lcg-expiregridmapdir','3.0.1-1','noarch');

# OTHER
'/software/packages' = pkg_repl('nagios-plugins-argus','1.1.0-1.el5','noarch');
'/software/packages' = pkg_repl('yaim-argus_server','1.6.0-1.el5','noarch');

#Andrea: Dependencies (to be put somewher else)
#'/software/packages' = pkg_repl("bouncycastle","1.45-6.el5","x86_64");
#'/software/packages' = pkg_repl("axis","1.2.1-2jpp.6","x86_64");
#'/software/packages' = pkg_repl("jakarta-commons-cli","1.0-6jpp_10.el5","x86_64");
#'/software/packages' = pkg_repl("jakarta-commons-lang","2.1-5jpp.1","x86_64");
#'/software/packages' = pkg_repl("log4j","1.2.13-3jpp.2","x86_64");
#'/software/packages' = pkg_repl("classpathx-jaf","1.0-9jpp.1","x86_64");
#'/software/packages' = pkg_repl("jakarta-commons-discovery","0.3-4jpp.1","x86_64");
#'/software/packages' = pkg_repl("jakarta-commons-httpclient","3.0-7jpp.1","x86_64");
#'/software/packages' = pkg_repl("jakarta-commons-logging","1.0.4-6jpp.1","x86_64");
#'/software/packages' = pkg_repl("java-1.4.2-gcj-compat","1.4.2.0-40jpp.115","x86_64");
#'/software/packages' = pkg_repl("wsdl4j","1.5.2-4jpp.1","x86_64");
#'/software/packages' = pkg_repl("gjdoc","0.7.7-12.el5","x86_64");
#'/software/packages' = pkg_repl("java-1.6.0-openjdk","1.6.0.0-1.11.b16.el5","x86_64");

