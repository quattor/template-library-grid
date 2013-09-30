# RPMs specific to MySQL flavor of LFC

unique template glite/lfc/rpms/x86_64/mysql;


'/software/packages' = pkg_repl("lfc-server-mysql","1.8.6-1.el5","x86_64");

'/software/packages' = pkg_repl("emi-lfc_mysql","1.8.6-2.el5","x86_64");




