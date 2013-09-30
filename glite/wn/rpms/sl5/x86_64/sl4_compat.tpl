unique template glite/wn/rpms/sl5/x86_64/sl4_compat;

include { 'config/emi/' + EMI_VERSION + '/wn-sl4-compat' };

"/software/packages/"=pkg_repl('HEP_OSlibs_SL5',HEP_OSlibs_VERSION,'x86_64');

# Add GSL on SL5 WNs
'/software/packages' = pkg_repl('gsl','1.12-1.el5.rf','i386');
'/software/packages' = pkg_repl('gsl','1.12-1.el5.rf','x86_64');

