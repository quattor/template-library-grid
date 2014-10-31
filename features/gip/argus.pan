unique template features/gip/argus;

# ---------------------------------------------------------------------------- 
# Glue 2 configuration
# ---------------------------------------------------------------------------- 
include { 'components/gip2/config' };
variable GIP_PROVIDER_SCRIPT ?= 'glite-info-glue2-provider-service-argus';
variable GIP_PROVIDER_TEMPLATES ?= list(
  '/etc/glite/info/service/glite-info-glue2-argus-pap.conf',
  '/etc/glite/info/service/glite-info-glue2-argus-pdp.conf',
  '/etc/glite/info/service/glite-info-glue2-argus-pep.conf');
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
  SELF[GIP_PROVIDER_SCRIPT] = SELF[GIP_PROVIDER_SCRIPT] + ' ' + SITE_NAME + "\n";
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


# ---------------------------------------------------------------------------- 
# Glue 1 configuration
# ---------------------------------------------------------------------------- 

variable GIP_GLUE1_PROVIDER_SCRIPT = 'glite-info-glue1-provider-service-argus';
variable GIP_GLUE1_PROVIDER_TEMPLATE = list(
  '/etc/glite/info/service/glite-info-service-argus-pap.conf',
  '/etc/glite/info/service/glite-info-service-argus-pep.conf',
  '/etc/glite/info/service/glite-info-service-argus-pdp.conf');

"/software/components/gip2/provider" = {
  glue1_template_id = 0;
  ok = first(GIP_GLUE1_PROVIDER_TEMPLATE,idx, tpl);
  glue1_provider_content = "";
  while ( ok ) {
    glue1_provider_content = format("%s /usr/bin/glite-info-service %s %s\n",glue1_provider_content,tpl,SITE_NAME);
    ok = next(GIP_GLUE1_PROVIDER_TEMPLATE,idx,tpl);
  };
  SELF[GIP_GLUE1_PROVIDER_SCRIPT] = glue1_provider_content;
  SELF;
};

'/software/components/filecopy/services' = {
  foreach(g1_template; file; GIP_GLUE1_PROVIDER_TEMPLATE) {
    SELF[escape(file)] = nlist(
      'source', file + '.template',
      'owner', 'root',
      'perms', '0644',
    );
  };
  SELF;
};
