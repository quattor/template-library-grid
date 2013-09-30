# RPMs common to both Oracle and MySQL VOMS versions.
# Based on VOMS 3.1.4 official RPM list.

unique template glite/voms/rpms/i386/base;

# RPMs provided by OS
include { 'config/glite/'+GLITE_VERSION+'/voms' };


'/software/packages' = pkg_repl('edg-mkgridmap', '3.0.0-1', 'noarch');
'/software/packages' = pkg_repl('edg-mkgridmap-conf', '3.0.0-1', 'noarch');
'/software/packages' = pkg_repl('glite-config', '3.1.0-3.slc4', 'i386');
'/software/packages' = pkg_repl('glite-info-generic', '2.0.2-3', 'noarch');
'/software/packages' = pkg_repl('glite-info-templates', '1.0.0-8', 'noarch');
'/software/packages' = pkg_repl('glite-security-trustmanager', '1.8.11-1', 'noarch');
'/software/packages' = pkg_repl('glite-security-util-java', '1.3.8-1', 'noarch');
'/software/packages' = pkg_repl('glite-security-utils-config', '3.1.0-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-admin-client', '2.0.5-1', 'noarch');
'/software/packages' = pkg_repl('glite-security-voms-admin-interface', '2.0.0-1', 'noarch');
'/software/packages' = pkg_repl('glite-security-voms-admin-server', '2.0.8-1', 'noarch');
'/software/packages' = pkg_repl('glite-security-voms-api-cpp', '1.7.22-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-clients', '1.7.22-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-config', '1.7.22-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-server', '1.7.22-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-version', '3.1.0-1.slc4', 'i386');
'/software/packages' = pkg_repl('glite-voms-server-config', '3.1.0-3.slc4', 'i386');
'/software/packages' = pkg_repl('gpt', 'VDT1.6.0x86_rhas_4-1', 'i386');
'/software/packages' = pkg_repl('lcg-expiregridmapdir', '2.0.0-1', 'noarch');
'/software/packages' = pkg_repl('lcg-info-templates', '1.0.15-1', 'noarch');
'/software/packages' = pkg_repl('lcg-vomscerts', '4.7.0-1', 'noarch');
'/software/packages' = pkg_repl('vdt_globus_essentials', 'VDT1.6.1x86_rhas_4-5', 'i386');


# External packages
'/software/packages' = pkg_repl('bcel', '5.2-3jpp', 'noarch');
'/software/packages' = pkg_repl('bouncycastle','1.37-5jpp','noarch');
'/software/packages' = pkg_repl('bouncycastle-jdk1.5','1.37-5jpp','noarch');
'/software/packages' = pkg_repl('ecj', '3.3.1.1-1jpp', 'noarch');
'/software/packages' = pkg_repl('gnu-crypto-sasl-jdk1.4','2.1.0-2jpp','noarch');
'/software/packages' = pkg_repl('jakarta-commons-beanutils', '1.7.0-6jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-collections', '3.2-2jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-collections-tomcat5', '3.2-2jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-daemon', '1.0.1-6jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-dbcp-tomcat5', '1.2.2-1jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-digester', '1.8-1jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-el', '1.0-7jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-launcher', '1.1-3jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-logging', '1.1-4jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-modeler', '2.0-4jpp', 'noarch');
'/software/packages' = pkg_repl('jakarta-commons-pool-tomcat5', '1.3-10jpp', 'noarch');
'/software/packages' = pkg_repl('log4j', '1.2.14-3jpp', 'noarch');
'/software/packages' = pkg_repl('mx4j', '3.0.1-7jpp', 'noarch');
'/software/packages' = pkg_repl('regexp', '1.4-3jpp', 'noarch');
'/software/packages' = pkg_repl('sun-jaf','1.1-3jpp','noarch');
'/software/packages' = pkg_repl('sun-mail','1.4-2jpp','noarch');
'/software/packages' = pkg_repl('tomcat5', '5.5.25-1jpp', 'noarch');
'/software/packages' = pkg_repl('tomcat5-common-lib', '5.5.25-1jpp', 'noarch');
'/software/packages' = pkg_repl('tomcat5-jasper', '5.5.25-1jpp', 'noarch');
'/software/packages' = pkg_repl('tomcat5-jsp-2.0-api', '5.5.25-1jpp', 'noarch');
'/software/packages' = pkg_repl('tomcat5-server-lib', '5.5.25-1jpp', 'noarch');
'/software/packages' = pkg_repl('tomcat5-servlet-2.4-api', '5.5.25-1jpp', 'noarch');
'/software/packages' = pkg_repl('xalan-c', '1.10.0-1.slc4', 'i686');
'/software/packages' = pkg_repl('xalan-j2', '2.7.0-7jpp', 'noarch');
'/software/packages' = pkg_repl('xerces-c', '2.7.0-1.slc4', 'i686');
'/software/packages' = pkg_repl('xerces-j2', '2.9.0-2jpp', 'noarch');
'/software/packages' = pkg_repl('xml-commons', '1.3.03-11jpp', 'noarch');
'/software/packages' = pkg_repl('xml-commons-jaxp-1.3-apis', '1.3.03-11jpp', 'noarch');
'/software/packages' = pkg_repl('xml-commons-resolver11', '1.3.03-11jpp', 'noarch');
'/software/packages' = pkg_repl('ZSI', '2.0-1.py2.3', 'noarch');

# External packages listed in official RPM list but not require by
# metapackage or any other packages
#'/software/packages' = pkg_repl('perl-URI', '1.30-4', 'noarch');
#'/software/packages' = pkg_repl('perl-libwww-perl', '5.79-5', 'noarch');
#'/software/packages' = pkg_repl('saxon', '6.5.3-5jpp', 'noarch');
#'/software/packages' = pkg_repl('perl-LDAP', '0.34-1.el4.rf', 'noarch');
#'/software/packages' = pkg_repl('perl-XML-NamespaceSupport', '1.09-1.2.el4.rf', 'noarch');
#'/software/packages' = pkg_repl('perl-XML-SAX', '0.16-1.el4.rf', 'noarch');


# Required by update 35
'/software/packages' = if ( GLITE_UPDATE_VERSION >= '35' ) {
                         pkg_repl('glite-security-voms-api-noglobus','1.8.8-2.slc4','i386');                      } else {
                         return(SELF);
                       };


