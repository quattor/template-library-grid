unique template glite/voms/config;

include { 'glite/voms/variables' };

include { 'glite/voms/tomcat' };
include { 'glite/voms/mysql' };
include { 'glite/voms/vos' };
include { 'common/gip/base' };

include { 'components/filecopy/config' };

'/software/components/filecopy/services/{/etc/sysconfig/voms}'=
  nlist(
    'config', file_contents('glite/voms/files/voms.sysconfig'),
    'owner', 'root:root',
    'perms', '0644',
);

include { 'components/chkconfig/config' };

 "/software/components/chkconfig/service/voms/on" = "";
 "/software/components/chkconfig/service/voms/startstop" = true;
 "/software/components/chkconfig/service/voms-admin/on" = "";
 "/software/components/chkconfig/service/voms-admin/startstop" = true;
