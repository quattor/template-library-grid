# Template to add update RPMs to base configuration

template update/08/rpms_thirdparty_sl6_i386;

'/software/packages'=pkg_ronly('activemq-cpp-library','3.2.5-1.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('axis1.4','1.4-1.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('c-ares','1.7.0-5.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('c-ares-devel','1.7.0-5.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('lcas-lcmaps-gt4-interface','0.2.1-4.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('xrootd','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('xrootd-client','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('xrootd-client-admin-java','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('xrootd-debuginfo','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('xrootd-devel','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('xrootd-fuse','3.2.7-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('xrootd-libs','3.2.7-1.el6','i386', '', '', 'emi');
