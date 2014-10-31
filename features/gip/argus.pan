unique template features/gip/argus;

# ---------------------------------------------------------------------------- 
# gip2
# ---------------------------------------------------------------------------- 
include { 'components/gip2/config' };
variable GIP_PROVIDER_SCRIPT ?= 'glite-info-glue2-provider-service-argus';
variable GIP_PROVIDER_TEMPLATES ?= list('/etc/glite/info/service/glite-info-glue2-argus-pap.conf','/etc/glite/info/service/glite-info-glue2-argus-pdp.conf','/etc/glite/info/service/glite-info-glue2-argus-pep.conf');
variable GIP_PROVIDER_ID ?= '/etc/glite/info/service/glite-info-glue2-service-argus.conf';


"/software/components/gip2/provider" = {
  if ( exists(SELF) && is_defined(SELF) && !is_nlist(SELF) ) {
    error('/software/components/gip2/provider must be an nlist');
  };

  SELF[GIP_PROVIDER_SCRIPT] = '/usr/bin/glite-info-glue2-multi ';
  i = 0;
  while (i < length(GIP_PROVIDER_TEMPLATES)) {
     SELF[GIP_PROVIDER_SCRIPT] = SELF[GIP_PROVIDER_SCRIPT] + GIP_PROVIDER_TEMPLATES[i];
     if (i < (length(GIP_PROVIDER_TEMPLATES) - 1)) {
       SELF[GIP_PROVIDER_SCRIPT] = SELF[GIP_PROVIDER_SCRIPT] + ',';
     };
     i = i + 1;
  };
  SELF[GIP_PROVIDER_SCRIPT] = SELF[GIP_PROVIDER_SCRIPT] + ' ' + SITE_NAME + ' ' + GIP_PROVIDER_ID;
  SELF;
};

include { 'components/filecopy/config' };
'/software/components/filecopy/services' = {
  foreach(i; file; GIP_PROVIDER_TEMPLATES) {
    SELF[escape(file)] = nlist(
      'source', file + '.template',
      'owner','root',
      'perms','0644',
    );
  };

  SELF;
};
