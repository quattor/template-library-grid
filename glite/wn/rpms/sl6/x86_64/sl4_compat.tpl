unique template glite/wn/rpms/sl6/x86_64/sl4_compat;

include { 'config/emi/' + EMI_VERSION + '/wn-sl4-compat' };

#ANDREA: to fix. There is not such a library on sl6
"/software/packages/"=pkg_repl('HEP_OSlibs_SL6',HEP_OSlibs_VERSION,'x86_64');

# Add GSL on SL5 WNs
'/software/packages' = pkg_repl('gsl','1.13-1.el6','i686');
'/software/packages' = pkg_repl('gsl','1.13-1.el6','x86_64');

