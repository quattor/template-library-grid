# This template is intended to be executed as part of node-specific VO configuration (NODE_VO_CONF)
# and enforces VOBOX specifities for the VO configuration (maximum number of VO allowed, FQAN authorized...)

unique template glite/vobox/init;

# List of VO allowed access to the VOBOX without configuring the VOBOX specific services for them.
variable VOBOX_OPERATION_VOS ?= list('ops');

# Allow gsissh access for operation VOS (only for the enabled FQANs as defined by VO_VOMS_FQAN_FILTER).
# Default: false
variable VOBOX_OPERATION_VOS_GSISSH ?= false;

# FQAN of the enabled VO is allowed access to the VOBOX.
# The value of this variable can be either a FQAN or a FQAN description matching the
# description in the VO parameters.
# Default: SW manager, except for ops (production). Ensure the specfic value defined for
# this node is taken first.
variable VO_VOMS_FQAN_FILTER = {
  if ( !is_defined(SELF['DEFAULT']) ) { 
    SELF['DEFAULT'] = 'SW manager';
  };
  debug('VO_GRIDMAPFILE_FQAN_FILTER='+to_string(SELF));
  SELF;
};


# Check that there is only one VO allowed access to the VOBOX in addition to operation VOS.
# Allow the variable handling the authorized VO to be a list for specific use case but it should
# never have more than one entry.
variable VOBOX_ENABLED_VOS = {
  foreach (i;vo;VOS) {
    if ( index(vo,VOBOX_OPERATION_VOS) < 0 ) {
      if ( is_defined(SELF) && (length(SELF) > 0) ) {
        error('More than one VO configured: '+SELF[0]+' already enabled, '+vo+' cannot be added');
      } else {
        SELF[length(SELF)] = vo;
      };
    };
  };
  if ( length(SELF) == 0 ) {
    debug('No VO enabled for VOBOX services: services will not be configured');
  } else {
    debug('VO enabled for VOBOX services: '+to_string(SELF)+', operation VOs: '+to_string(VOBOX_OPERATION_VOS));
  };
  SELF;
};

# Ensure operation VOs are listed in VOS
variable VOS = {
  foreach (i;vo;VOBOX_OPERATION_VOS) {
    if ( index(vo,VOS) < 0 ) {
      SELF[length(SELF)] = vo;
    };
  };
  debug('List of VOs with access to the VOBOX (VOS): '+to_string(VOS));
  SELF;
};

# Unlock VO accounts for enabled VOs.
# This is done by adding the necessary 'unlock_account' entry in VOS_SITE_PARAMS.
variable VOS_SITE_PARAMS = {
  if ( VOBOX_OPERATION_VOS_GSISSH ) {
    gsi_ssh_vos = merge(VOBOX_ENABLED_VOS,VOBOX_OPERATION_VOS);
  } else {
    gsi_ssh_vos = VOBOX_ENABLED_VOS;
  };
  foreach (i;vo;gsi_ssh_vos) {
    if ( !is_nlist(SELF[vo]) ) {
      if ( is_defined(SELF[vo]) ) {
        debug('VOS_SITE_PARAMS entry for VO '+vo+' is not a nlist. Resetting it.');
        SELF[vo] = undef;
      };
      SELF[vo] = nlist();
    };
    if ( is_defined(SELF[vo]['unlock_accounts']) ) {
      if (match(FULL_HOSTNAME,SELF[vo]['unlock_accounts'])) {
        debug('VOBOX accounts for VO '+vo+' already enabled');
      } else {
        debug('Enabling VOBOX accounts for VO '+vo+' (current definition of VOS_SITE_PARAMS['+vo+']["unlock_accounts"] inappropriate, resetting)');
        SELF[vo]['unlock_accounts'] = FULL_HOSTNAME;
      };
    } else {
      debug('Enabling VOBOX accounts for VO '+vo);
      SELF[vo]['unlock_accounts'] = FULL_HOSTNAME;
    };
  };
  SELF;
};
