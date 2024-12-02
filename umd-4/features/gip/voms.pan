unique template features/gip/voms;

include { 'components/gip2/config' };

prefix '/software/components/gip2';


'confFiles/{/etc/bdii/gip/glite-info-service-voms.conf}'= <<EOF;
init = glite-info-service-voms $GLITE_INFO_SERVICE_VO
service_type = org.glite.voms
get_version = rpm -q voms-server --queryformat '%{version}\n'
get_endpoint = echo voms://$VOMS_HOST:$VOMS_PORT/$VOMS_VO
get_status = glite-info-service-test VOMS && /etc/init.d/voms status $VOMS_VO
WSDL_URL = nohttp://not.a.web.service/
semantics_URL = https://twiki.cern.ch/twiki/pub/EMI/EMIVomsDocumentation/voms-guide-2.0.0.pdf
get_starttime = perl -e '@st=stat($ENV{VOMS_LOCK_FILE});print "@st[10]\n";'
get_owner = echo $VOMS_VO
get_acbr = echo VO:$VOMS_VO
get_data = echo
get_services = echo
get_implementationname = echo VOMS
get_implementationversion = rpm -q --qf %{V} voms-server
EOF

'confFiles/{/etc/bdii/gip/glite-info-service-voms-admin.conf}'= <<EOF;
init = glite-info-service-voms-admin
service_type = org.glite.voms-admin
get_version = rpm -q voms-admin-server --queryformat '%{version}\n'
get_endpoint = echo https://$VOMS_ADMIN_HOST:$VOMS_ADMIN_PORT/vomses/
get_status = glite-info-service-test VOMS_ADMIN && /sbin/service tomcat5 status
WSDL_URL = http://svn.research-infrastructures.eu/public/d4science/gcube/trunk/vo-management/VOMS-ADMIN/schema/glite-security-voms-admin-2.0.2.wsdl
semantics_URL = https://twiki.cern.ch/twiki/bin/view/EMI/EMIVomsAdminUserGuide261
get_starttime = perl -e '@st=stat($ENV{VOMS_ADMIN_PID_FILE});print "@st[10]\n";'
get_owner = cat /etc/voms/*/voms.conf | grep [\-]-vo | cut -d= -f2
get_acbr = cat /etc/voms/*/voms.conf | grep [\-]-vo | cut -d= -f2 | xargs -i echo VO:{}
get_data = cat /etc/voms/*/voms.conf | grep [\-]-vo | cut -d= -f2 | xargs -i echo Endpoint-{}=https://$VOMS_ADMIN_HOST:$VOMS_ADMIN_PORT/voms/{}/
get_services = echo
EOF

'provider/glite-info-service-voms-glue2'=format(file_contents('features/gip/files/provider.voms-glue2'),
  FULL_HOSTNAME,
  "/etc/bdii/gip/",
  SITE_NAME,
);

'provider/glite-info-service-voms'=format(file_contents('features/gip/files/provider.voms'),
  FULL_HOSTNAME,
  "/etc/bdii/gip/",
  SITE_NAME,
);

'provider/glite-info-service-voms-admin'=format(file_contents('features/gip/files/provider.voms-admin'),
  FULL_HOSTNAME,
  "/etc/bdii/gip/",
  SITE_NAME,
);

'confFiles/{/etc/bdii/gip/default-ldif.conf}'= <<EOF;
dn: o=shadow
objectClass: organization
o: o=shadow

dn: o=grid
objectClass: organization
o: grid

dn: mds-vo-name=local,o=grid
objectClass: MDS
mds-vo-name: local

dn: mds-vo-name=resource,o=grid
objectClass: MDS
mds-vo-name: resource

dn: o=glue
objectClass: organization
o: glue

dn: GLUE2GroupID=resource, o=glue
objectClass: GLUE2Group
GLUE2GroupID: resource

dn: GLUE2GroupID=grid, o=glue
objectClass: GLUE2Group
GLUE2GroupID: grid
EOF

'ldif/default/entries'=nlist();
'ldif/default/ldifFile'='default.ldif';
'ldif/default/template'='/etc/bdii/gip/default-ldif.conf';

'staticInfoCmd'='/var/run/quattor/static-ldif';

include { 'components/chkconfig/config' };

'/software/components/chkconfig/service/bdii/on'='';
'/software/components/chkconfig/service/bdii/startstop'=true;

include { 'components/filecopy/config' };
'/software/components/gip2/dependencies/pre' = append('filecopy');

variable CONTENTS = <<EOF;
#!/bin/sh

/bin/cat $4
EOF

'/software/components/filecopy/services/{/var/run/quattor/static-ldif}'=
nlist(
  'config', CONTENTS,
  'owner', 'root:root',
  'perms', '0755',
);
