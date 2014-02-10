unique template common/accounting/apel/rpms/x86_64/parser_pbs;

include { 'config/emi/' + EMI_VERSION  + '/apel' };

# EMI
'/software/packages' = pkg_repl('glite-apel-core','2.0.14-5.sl5','noarch'); 
'/software/packages' = pkg_repl('glite-apel-pbs','2.0.6-8.sl5','noarch');   
'/software/packages' = pkg_repl('mm-mysql','3.1.8-2.sl5','noarch');

# EPEL
'/software/packages' = pkg_repl('bouncycastle','1.45-6.el5','x86_64');
'/software/packages' = pkg_repl('mysql-connector-java', '5.1.12-2.el5', 'x86_64');
