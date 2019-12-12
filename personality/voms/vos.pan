# Template to build the VO list for the VOMS server based on VOs configured
unique template personality/voms/vos;

include 'components/filecopy/config';

variable VOS ?= list();
variable VOS = {
    result = SELF;
    if ( is_defined(VOMS_VOS) && (length(VOMS_VOS) == 0) ) {
        foreach (vo; params; VOMS_VOS) {
            result = append(result, vo);
        };
    };
    result;
};


variable CONTENTS = {
    cmds = list(
        "#!/bin/sh",
    );
    if ( is_defined(VOMS_VOS) && (length(VOMS_VOS) != 0) ) {
        foreach (vo; params; VOMS_VOS) {
            cmd = list(
                "/usr/sbin/voms-configure",
                "install",
                "--dbtype mysql",
                format("--vo %s", vo),
                "--createdb",
                "--deploy-database",
                substitute("--dbauser ${dbUser}", params),
                substitute("--dbapwd '${dbPassword}'", params),
                substitute("--dbusername ${dbUser}'", params),
                substitute("--dbpassword '${dbPassword}'", params),
                substitute("--core-port ${port}", params),
                substitute("--dbname ${dbName}", params),
                if (exists(params['timeout'])) {
                    substitute('--timeout ${timeout}', params);
                },
                '--csrf-log-only',
                substitute("--mail-from ${adminEmail}", params)
                format('--smtp-host %s', VOMS_ADMIN_SMTP_HOST),
            );
            cmds = append(cmds, join(' ', cmd));
            cmds = append(cmds, format(
                "/usr/sbin/voms-db-util add-admin --vo %s --cert /etc/grid-security/hostcert.pem",
                vo,
            ));
        };
    };
    cmds = append(cmds, "service voms restart");
    cmds = append(cmds, "service voms-admin stop; service voms-admin start");
    join("\n", cmds);
};


'/software/components/filecopy/services/{/var/run/quattor/create-voms.sh}' = dict(
    'config', CONTENTS,
    'owner', 'root:root',
    'perms', '0755',
    'restart', if (VOMS_TOMCAT_RESTART_CONFIG) {
        '/var/run/quattor/create-voms.sh';
    } else {
        null;
    },
);
