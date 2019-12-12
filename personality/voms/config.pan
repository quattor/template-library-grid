unique template personality/voms/config;

include 'components/chkconfig/config';
include 'components/filecopy/config';

include 'personality/voms/mysql';
include 'personality/voms/variables';
include 'personality/voms/vos';

include 'features/gip/base';

prefix '/software/components/filecopy/services';

'{/etc/sysconfig/voms}' = dict(
    'config', file_contents('personality/voms/files/voms.sysconfig'),
    'owner', 'root:root',
    'perms', '0644',
);

'{/etc/sysconfig/voms-admin}' = dict(
    'config', format(
        file_contents('personality/voms/files/voms-admin.sysconfig'),
        VOMS_TOMCAT_MS,
        VOMS_TOMCAT_MX,
        VOMS_TOMCAT_MAXPERMSIZE
    ),
    'owner', 'root:root',
    'perms', '0644',
);

prefix "/software/components/chkconfig/service";

"voms/on" = "";
"voms/startstop" = true;

"voms-admin/on" = "";
"voms-admin/startstop" = true;
