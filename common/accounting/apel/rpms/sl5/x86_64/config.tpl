unique template common/accounting/apel/rpms/sl5/x86_64/config;

include { 'config/emi/' + PUBLISHER_VERSION  + '/apel' };

'/software/packages' = pkg_repl('glite-apel-core','2.0.14-5.sl5','noarch');
'/software/packages' = pkg_repl('bouncycastle','1.45-6.el5','x86_64');

'/software/packages' = {
  if (PUBLISHER_VERSION == "2.0") {
    # EMI
    pkg_repl('glite-apel-pbs','2.0.6-8.sl5','noarch');   
    pkg_repl('mm-mysql','3.1.8-2.sl5','noarch');
    # EPEL
    pkg_repl('mysql-connector-java', '5.1.12-2.el5', 'x86_64');
  } else {
    # EMI
    pkg_repl('apel-parsers','1.1.2-0.el5','noarch');
    pkg_repl('apel-lib','1.1.2-0.el5','noarch');
    # EPEL
    pkg_repl('python-iso8601','0.1.4-2.el5','noarch');
  };
};
