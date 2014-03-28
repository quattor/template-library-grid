unique template feature/gip/lfc;

# ---------------------------------------------------------------------------- 
# gip2
# ---------------------------------------------------------------------------- 
include { 'components/gip2/config' };


variable DLI_PORT ?= 8085;

# This sets up the VOs for "central" and "local" LFC instances.  The default
# is that no central instances are set up and the local instances are for
# all the VOs listed in the VOS variable.
#
# This can be overridden by defining the lists below before including this
# template.

variable LFC_CENTRAL_VOS ?= list();
# VOs listed both in LFC_CENTRAL_VOS and LFC_LOCAL_VOS will be removed from LFC_LOCAL_VOS
variable LFC_LOCAL_VOS ?= VOS;

# Alias for LFC host name
variable LFC_ALIAS = if ( exists(LFC_HOSTS[FULL_HOSTNAME]['alias']) && is_defined(LFC_HOSTS[FULL_HOSTNAME]['alias']) ) {
                       return(LFC_HOSTS[FULL_HOSTNAME]['alias']);
                     } else {
                       return(undef);
                     };
variable LFC_ALIAS_OPTION = if ( is_defined(LFC_ALIAS) ) {
                              return(' --alias '+LFC_ALIAS);
                            } else {
                              return('');
                            };

# Build a nlist of all central VOs for easier processing of LFC_LOCAL_VOS (value has no meaning)
variable LFC_CENTRAL_VOS_NAMES = {
  vos = LFC_CENTRAL_VOS;
  foreach (k;v;LFC_CENTRAL_VOS) {
    SELF[v] = v;
  };
  SELF;
};

# LFC_CENTRAL_VOS_OPTIONS contains the list of all VOS listed in LFC_CENTRAL_VOS, using VO full name
variable LFC_CENTRAL_VOS_OPTION = {
  result = '';
  foreach (k;v;LFC_CENTRAL_VOS) {
    if ( exists(VO_INFO[v]) && is_defined(VO_INFO[v]) ) {
      result = result + ' ' + VO_INFO[v]['name'];
    } else {
      error('VO '+v+' in LFC_LOCAL_VOS not supported on this node (not present in VOS)');
    };
  };
  if ( length(result) > 0 ) {
    toks = matches(result,'^\s+(.*)$');
    result = ' --central "' + toks[1] +'"';
  };
  result;
};

# LFC_LOCAL_VOS_OPTION contain all the VOs from LFC_LOCAL_VOS (default to VOS)
# except those in LFC_CENTRAL_VOS
variable LFC_LOCAL_VOS_OPTION = {
  result = '';
  foreach (k;v;LFC_LOCAL_VOS) {
    if ( !exists(LFC_CENTRAL_VOS_NAMES[v]) ) {
      if ( exists(VO_INFO[v]) && is_defined(VO_INFO[v]) ) {
        result = result + ' ' + VO_INFO[v]['name'];
      } else {
        error('VO '+v+' in LFC_LOCAL_VOS not supported on this node (not present in VOS)');
      };
    };
  };
  if ( length(result) > 0 ) {
    toks = matches(result,'^\s+(.*)$');
    result = ' --local "' + toks[1] +'"';
  };
  result;
};

"/software/components/gip2/provider" = {
  if ( exists(SELF) && is_defined(SELF) && !is_nlist(SELF) ) {
    error('/software/components/gip2/provider must be an nlist');
  };

  SELF['glite-lfc-provider'] = LCG_INFO_SCRIPTS_DIR + '/lcg-info-provider-lfc --site ' + SITE_NAME +
                               LFC_LOCAL_VOS_OPTION+LFC_CENTRAL_VOS_OPTION+LFC_ALIAS_OPTION;

  SELF['glite-lfc-provider-glue2'] = LCG_INFO_SCRIPTS_DIR + '/lcg-info-provider-lfc --glue2 --site ' + SITE_NAME +
                                     LFC_LOCAL_VOS_OPTION+LFC_CENTRAL_VOS_OPTION+LFC_ALIAS_OPTION;

  SELF;
};


# Configure provider to return gLite version used by the service
include { 'feature/gip/glite-version' };

