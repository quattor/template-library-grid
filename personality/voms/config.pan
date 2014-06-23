unique template personality/voms/config;

include { 'personality/voms/variables' };

include { 'personality/voms/mysql' };
include { 'personality/voms/vos' };
include { 'features/gip/base' };

include { 'components/filecopy/config' };
prefix '/software/components/filecopy/services';
'{/etc/sysconfig/voms}'=
  nlist(
    'config', file_contents('personality/voms/files/voms.sysconfig'),
    'owner', 'root:root',
    'perms', '0644',
);

'{/etc/sysconfig/voms-admin}' =
  nlist(
    'config', format(file_contents('personality/voms/files/voms-admin.sysconfig'),
                     VOMS_TOMCAT_MS,
                     VOMS_TOMCAT_MX,
                     VOMS_TOMCAT_MAXPERMSIZE
                     ),
    'owner', 'root:root',
    'perms', '0644',
);

include { 'components/chkconfig/config' };

 "/software/components/chkconfig/service/voms/on" = "";
 "/software/components/chkconfig/service/voms/startstop" = true;
 "/software/components/chkconfig/service/voms-admin/on" = "";
 "/software/components/chkconfig/service/voms-admin/startstop" = true;
