unique template personality/voms/tomcat;

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

'services/{/var/run/quattor/certificate-copy.sh}'=
  nlist(
    'config', format(file_contents('personality/voms/files/certificate-copy.sh'),
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
