unique template personality/voms/tomcat;

include 'components/filecopy/config';
include 'components/symlink/config';

prefix '/software/components/symlink';

'links' ?= list();
'links' = append(SELF, list(
    dict(
        "name", VOMS_TOMCAT_COMMON_LIB+"/xalan-j2-serializer.jar",
        "target", "/usr/share/java/xalan-j2-serializer.jar",
        "replace", dict("all", "yes"),
    ),
    dict(
        "name", VOMS_TOMCAT_COMMON_LIB+"/xalan-j2.jar",
        "target", "/usr/share/java/xalan-j2.jar",
        "replace", dict("all", "yes"),
    ),
    dict(
        "name", VOMS_TOMCAT_SERVER_LIB+"/bcprov.jar",
        "target", "/usr/share/java/bcprov.jar",
        "replace", dict("all", "yes"),
    ),
    dict(
        "name", VOMS_TOMCAT_SERVER_LIB+"/trustmanager.jar",
        "target", "/usr/share/java/trustmanager.jar",
        "replace", dict("all", "yes"),
    ),
    dict(
        "name", VOMS_TOMCAT_SERVER_LIB+"/trustmanager-tomcat.jar",
        "target", "/usr/share/java/trustmanager-tomcat.jar",
        "replace", dict("all", "yes"),
    ),
    dict(
        "name", VOMS_TOMCAT_SERVER_LIB+"/log4j.jar",
        "target", "/usr/share/java/log4j.jar",
        "replace", dict("all", "yes"),
    ),
);

prefix '/software/components/filecopy';

'services/{/var/run/quattor/certificate-copy.sh}' = dict(
    'config', format(
        file_contents('personality/voms/files/certificate-copy.sh'),
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

'services/{/etc/security/limits.conf}' = if (VOMS_TOMCAT_MANAGE_LIMITS_FILE) {
    dict(
        'config', format("%1$s soft nofile 65536\n%1$s hard nofile 65536\n", VOMS_TOMCAT_USER),
        'owner', 'root:root',
        'perms', '0644',
    );
} else {
    null;
};
