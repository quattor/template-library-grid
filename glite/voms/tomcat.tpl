unique template glite/voms/tomcat;

# Configure Tomcat user
variable TOMCAT_USER ?= VOMS_TOMCAT_USER;
include { 'users/tomcat' };

include { 'components/symlink/config' };
prefix '/software/components/symlink';

'links'= push(
  nlist("name",    VOMS_TOMCAT_COMMON_LIB+"/xalan-j2-serializer.jar",
        "target",  "/usr/share/java/xalan-j2-serializer.jar",
        "replace", nlist("all","yes"),
  ),
  nlist("name",    VOMS_TOMCAT_COMMON_LIB+"/xalan-j2.jar",
        "target",  "/usr/share/java/xalan-j2.jar",
        "replace", nlist("all","yes"),
  ),
  nlist("name",    VOMS_TOMCAT_SERVER_LIB+"/bcprov.jar",
        "target",  "/usr/share/java/bcprov.jar",
        "replace", nlist("all","yes"),
  ),
  nlist("name",    VOMS_TOMCAT_SERVER_LIB+"/trustmanager.jar",
        "target",  "/usr/share/java/trustmanager.jar",
        "replace", nlist("all","yes"),
 ),
 nlist("name",    VOMS_TOMCAT_SERVER_LIB+"/trustmanager-tomcat.jar",
       "target",  "/usr/share/java/trustmanager-tomcat.jar",
       "replace", nlist("all","yes"),
 ),
 nlist("name",    VOMS_TOMCAT_SERVER_LIB+"/log4j.jar",
       "target",  "/usr/share/java/log4j.jar",
       "replace", nlist("all","yes"),
 ),
);
include { 'components/filecopy/config' };

prefix '/software/components/filecopy';

'services/{/etc/tomcat5/tomcat5.conf}'=
  nlist(
    'config',format(file_contents('glite/voms/files/tomcat5.conf'),
                     VOMS_TOMCAT_HOME,
                     VOMS_TOMCAT_HOME,
                     VOMS_TOMCAT_HOME,
                     VOMS_TOMCAT_HOME,
                     VOMS_TOMCAT_USER,
                     VOMS_TOMCAT_MX,
                     VOMS_TOMCAT_MAXPERMSIZE,
             ),
    'owner', 'tomcat:tomcat',
    'perms', '0755',
);

'services/{/etc/tomcat5/server.xml}'=
  nlist(
    'config',file_contents('glite/voms/files/server.xml'),
    'owner', 'tomcat:tomcat',
    'perms', '0755',
);

'services/{/etc/tomcat5/log4j-trustmanager.properties}'=
  nlist(
    'config', file_contents('glite/voms/files/log4j-trustmanager.properties'),
    'owner' , 'tomcat:tomcat',
    'perms' , '0755',
);

'services/{/var/run/quattor/certificate-copy.sh}'=
  nlist(
    'config', format(file_contents('glite/voms/files/certificate-copy.sh'),
               VOMS_CERT_LAST_UPDATE,
               VOMS_ROOT_CERT,
               VOMS_TOMCAT_CERT,
               VOMS_ROOT_CERTKEY,
               VOMS_TOMCAT_CERTKEY,
               VOMS_TOMCAT_USER,
               VOMS_TOMCAT_USER,
             ),
    'owner', 'root:root',
    'perms', '0755',
    'restart', '/var/run/quattor/certificate-copy.sh',
);

variable CONTENTS = VOMS_TOMCAT_USER + " soft nofile 65536\n";
variable CONTENTS = CONTENTS + VOMS_TOMCAT_USER + " hard nofile 65536\n";

'services'={
  if ( VOMS_TOMCAT_MANAGE_LIMITS_FILE ) {
    SELF[escape('/etc/security/limits.conf')]=
      nlist(
        'config', CONTENTS,
        'owner', 'root:root',
        'perms', '0644',
      );
  };
  SELF;
};

include { 'components/chkconfig/config' };

 "/software/components/chkconfig/service/tomcat5/on" = "";
 "/software/components/chkconfig/service/tomcat5/startstop" = true;
