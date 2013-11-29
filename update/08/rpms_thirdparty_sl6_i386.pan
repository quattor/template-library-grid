# Template to add update RPMs to base configuration

template update/08/rpms_thirdparty_sl6_i386;

'/software/packages'=pkg_ronly('activemq-cpp-library','3.2.5-3.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('activemq-cpp-library-debuginfo','3.2.5-3.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('axis1.4','1.4-1.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('bouncycastle-mail','1.46-1.sl6','noarch', '', '', 'emi');
'/software/packages'=pkg_ronly('c-ares','1.7.0-5.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('c-ares-devel','1.7.0-5.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('lcas-lcmaps-gt4-interface','0.2.6-1.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('lcas-lcmaps-gt4-interface','0.2.1-4.el6','i686', '', '', 'emi');
'/software/packages'=pkg_ronly('maui','3.3-4.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('maui-client','3.3-4.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('maui-debuginfo','3.3-4.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('maui-devel','3.3-4.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('maui-server','3.3-4.el6','i386', '', '', 'emi');
'/software/packages'=pkg_ronly('maven','2.2.1-1emi.sl6','noarch', '', '', 'emi');
