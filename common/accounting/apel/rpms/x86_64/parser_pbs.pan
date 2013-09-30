unique template common/accounting/apel/rpms/x86_64/parser_pbs;

include { 'config/emi/' + EMI_VERSION  + '/apel' };

'/software/packages' = pkg_repl("glite-apel-core","2.0.14-5.sl5","noarch"); 

'/software/packages' = pkg_repl("glite-apel-pbs","2.0.6-8.sl5","noarch");   
'/software/packages' = pkg_repl("bouncycastle","1.45-6.el5","x86_64"); # EPEL
"/software/packages"=pkg_repl("java-1.6.0-openjdk","1.6.0.0-1.11.b16.el5","x86_64"); # OS
"/software/packages"=pkg_repl("mm-mysql","3.1.8-2.sl5","noarch");
"/software/packages"=pkg_repl("mysql-connector-java", "5.1.12-2.el5", "x86_64"); # EPEL
#"/software/packages"=pkg_repl("geronimo-jta-1.0.1B-api","1.2-13.jpp5","noarch");
#"/software/packages"=pkg_repl("geronimo-specs-poms","1.2-13.jpp5","noarch");

#'/software/packages' = pkg_repl();
'/software/packages' = pkg_repl("mysql-connector-java","5.1.12-2.el5","x86_64");
