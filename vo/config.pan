# Template to configure VOs for a specific node (including pool account
# creation)
#
# Some variables can be used to customize this template behaviour

template vo/config;

# Template defining aliases for VO names.
variable VOS_ALIASES_TEMPLATE ?= 'vo/site/aliases';

variable GLITE_VO_STYLE ?= false;
# Define uid/gid max value for dynamic ID allocation by useradd.
# This value ensures that all accounts created by QWG templates are
# not protected when using preserved_accounts=dyn_user_group in ncm-accounts
variable NODE_VO_UID_MAX ?= 599;
variable NODE_VO_GID_MAX ?= 599;
# For backward compatibility, use NODE_VO_POOLACCOUNTS if it exists
# Sites must undefined NODE_VO_POOLACCOUNTS to use the new variable.
variable NODE_VO_ACCOUNTS = if ( exists(NODE_VO_POOLACCOUNTS) && is_defined(NODE_VO_POOLACCOUNTS) ) {
                              NODE_VO_POOLACCOUNTS;
                            } else {
                              if ( exists(NODE_VO_ACCOUNTS) && is_defined(NODE_VO_ACCOUNTS) ) {
                                SELF;
                              } else {
                                true;
                              };
                            };
variable NODE_VO_GRIDMAPDIR_CONFIG ?= false;
variable NODE_VO_CONFIG ?= null;
variable NODE_VO_WLCONFIG ?= false;
variable NODE_VO_VOMSCLIENT ?= true;
variable NODE_VO_INFO_DIR ?= false;
variable NODE_VO_PROFILE_ENV ?= false;
# Used to force an explicit definition of home dir and provide a way to reset
# home directories to a default value, without an explicit definition for each VO.
# Define to undef to suppress explicit definition of default home directory.
variable VAR_EXISTS = exists(NODE_VO_DEFAULT_HOMEROOT);
variable NODE_VO_DEFAULT_HOMEROOT ?= if (VAR_EXISTS) {
                                        undef;
                                     } else {
                                        "/home";
                                     };

variable GSISSH_SERVER_ENABLED ?= false;

# use NODE_VO_CREATEHOME to avoid site effects with CREATE_HOME default
# value multiple defintions.
# If CREATE_HOME is not explicitly defined, NODE_VO_CREATEHOME generally
# defaults to false.
variable NODE_VO_CREATEHOME = if ( exists(CREATE_HOME) ) {
                                CREATE_HOME;
			                        } else {
                                false;
                              };
# Reset CREATE_HOME to the computed value of NODE_VO_CREATEHOME to replace
# possible temporary default values.
variable CREATE_HOME = NODE_VO_CREATEHOME;


# Include local node specific VO configuration
# (e.g. node specific VO list)
include { NODE_VO_CONFIG };


# Check VO list is defined and handle special value 'ALL' (configure all possible VOs).
# Also allows VOS to a be string instead of a list and convert it to a list.
variable VOS ?= { error('vo/config : VO list (VOS) undefined'); };
variable VOS = if ( is_list(SELF) ) {
                 SELF;
               } else {
                 error('Invalid value for VOS ('+to_string(VOS)+'. Must be a list.');
               };


# Load VO aliases (required for checking GSISSH_SERVER_VOS
include { if_exists(VOS_ALIASES_TEMPLATE) };


# Create and enable pool accounts on a gsissh UI (or a machine with a gsissh server enabled).
# Except if an explicit list of VO has been given, enable all supported VOs (NODE_VO_ACCOUNT_LIST is the list
# of VO for which accounts must be created).
# Check if an alias is used to specify a VO when VOS=ALL as this is not supported in this
# particular case.
# Note: gsissh-related account configuration is done latr on VOBOX.

variable GSISSH_SERVER_VOS ?= VOS;
variable NODE_VO_ACCOUNT_LIST ?= {
  if ( GSISSH_SERVER_ENABLED ) {
    # Checked VOs enabled for gsissh use are part of supported VOs
    unsupported_vos = list();
    aliased_vos = list();
    actual_vos = list();
    foreach (i;vo;GSISSH_SERVER_VOS) {
      if ( index(vo,VOS) < 0 ) {
        if ( exists(VOS_ALIASES[vo]) ) {
          aliased_vos[length(aliased_vos)] = vo;
          actual_vos[length(actual_vos)] = VOS_ALIASES[vo];
        } else {
          unsupported_vos[length(unsupported_vos)] = vo;
        };
      };
    };
    if ( length(aliased_vos) > 0 ) {
        error('VO names '+to_string(aliased_vos)+' are aliases. Use VO full names instead '+to_string(actual_vos)+'.');
    };
    if ( length(unsupported_vos) > 0 ) {
        error('VOs '+to_string(unsupported_vos)+' enabled for gsissh access but not part of supported VOs');
    };
    GSISSH_SERVER_VOS;
  } else {
    VOS;
  };
};
variable VOS_SITE_PARAMS = {
  if ( GSISSH_SERVER_ENABLED ) {
    foreach (i;vo;GSISSH_SERVER_VOS) {
      debug('Ensuring VO '+vo+' pool accounts will be unlocked for gsissh access');
      if ( !exists(SELF[vo]['unlock_accounts']) ) {
        if ( !exists(SELF[vo]) ) {
        SELF[vo] = nlist();
        };
        SELF[vo]["unlock_accounts"] = FULL_HOSTNAME;
      };
    };
  };
  if ( is_defined(SELF) ) {
    SELF;
  } else {
    nlist();
  };
};


# Include VO parameters and functions
include { 'vo/functions' };
include { 'vo/init' };


# Build a list of VO full names (unaliased names).
# Must be done after reading VO parameters.

variable VOS_FULL = {
  vo_num = 0;
  foreach(k;vo;VOS) {
    SELF[vo_num] = VO_INFO[vo]['name'];
    vo_num = length(SELF);
  };
  SELF;
};


#
# Virtual organization configuration.
#
'/system/vo' = combine_system_vo(VOS);

# Create pool accounts
variable ACCOUNTS_INCLUDE = if ( NODE_VO_ACCOUNTS ) {
                                "components/accounts/config";
                            } else {
                                null;
                            };
include { ACCOUNTS_INCLUDE };

'/software/components/accounts/login_defs/uid_max' = if ( NODE_VO_ACCOUNTS ) {
                                                        NODE_VO_UID_MAX;
                                                     } else {
                                                        if ( exists(SELF) && is_defined(SELF) ) {
                                                          SELF;
                                                        } else {
                                                          null;
                                                        };
                                                     };
'/software/components/accounts/login_defs/gid_max' = if ( NODE_VO_ACCOUNTS ) {
                                                        NODE_VO_GID_MAX;
                                                     } else {
                                                        if ( exists(SELF) && is_defined(SELF) ) {
                                                          SELF;
                                                        } else {
                                                          null;
                                                        };
                                                     };
'/software/components/accounts' = if ( NODE_VO_ACCOUNTS ) {
                                       combine_vo_accounts(NODE_VO_ACCOUNT_LIST);
                                    } else {
                                       if ( exists(SELF) && is_defined(SELF) ) {
                                         SELF;
                                       } else {
                                         null;
                                       };
                                    };

# Create SW area if needed
include { 'components/dirperm/config' };
'/software/components/dirperm' = combine_dirperm_paths(VOS,'swarea');

# Configure environment variables for each VOs

variable PROFILE_ENV_INCLUDE = if ( NODE_VO_PROFILE_ENV ) { 
                                 "components/profile/config";
                               } else {
                                 null;
                               };
include { PROFILE_ENV_INCLUDE };
# For backward compatibility, now deprecated
variable SE_HOST_DEFAULT_SC3 ?= null;
'/software/components/profile' = if ( NODE_VO_PROFILE_ENV ) {
                                   combine_vo_env(VOS,VO_SW_AREAS,CE_VO_DEFAULT_SE,SE_HOST_DEFAULT_SC3);
                                 } else {
                                   if ( exists(SELF) && is_defined(SELF) ) {
                                     SELF;
                                   } else {
                                     null;          
                                   };
                                 };

# Configure permission for pool accounts home directories
'/software/components/dirperm' = if ( NODE_VO_INFO_DIR ) {
                                       combine_dirperm_paths(VOS,'voinfo');
                                    } else {
                                       if ( exists(SELF) && is_defined(SELF) ) {
                                         SELF;
                                       } else {
                                         null;
                                       };
                                    };

# Configure gridmapdir
variable GRIDMAPDIR_INCLUDE = if ( NODE_VO_GRIDMAPDIR_CONFIG ) { 
                                "components/gridmapdir/config";
                            } else {
                                null;
                            };
include { GRIDMAPDIR_INCLUDE };
'/software/components/gridmapdir' = if ( NODE_VO_GRIDMAPDIR_CONFIG ) {
                                       combine_gridmapdir_poolaccounts(NODE_VO_ACCOUNT_LIST);
                                    } else {
                                       null;
                                    };

# Set an explicit list of VOs for mkgridmap if GSISSH_SERVER_ENABLED
variable MKGRIDMAP_INCLUDE = if ( GSISSH_SERVER_ENABLED ) { 
                               "components/mkgridmap/config";
                             } else {
                               undef;
                             };
include { MKGRIDMAP_INCLUDE };
'/software/components/mkgridmap' = {
  if ( is_defined(MKGRIDMAP_INCLUDE) ) { 
    SELF['voList'] = NODE_VO_ACCOUNT_LIST;
  };
  if ( is_defined(SELF) ) {
    SELF;
  } else {
    null;
  };
};

# Configure Workload Manager
variable WLCONFIG_INCLUDE = if ( NODE_VO_WLCONFIG ) { 
                                "components/wlconfig/config";
                            } else {
                                null;
                            };
include { WLCONFIG_INCLUDE };
'/software/components/wlconfig' = if ( NODE_VO_WLCONFIG ) {
                                      combine_wlconfig_networkserver(VOS);
                                  } else {
                                      null;
                                  };
                                                
# Configure VOMS client
variable VOMSCLIENT_CONFIG = if ( NODE_VO_VOMSCLIENT ) { 
                               "features/security/vomsclient";
                             } else {
                               null;
                             };
include { VOMSCLIENT_CONFIG };
variable VOMSCLIENT_INCLUDE = if ( NODE_VO_VOMSCLIENT ) {
                                "components/vomsclient/config";
                              } else {
                                null;
                              };
include { VOMSCLIENT_INCLUDE };
'/software/components/vomsclient' = if ( NODE_VO_VOMSCLIENT ) {
                                      combine_vomsclient_vos(VOS);
                                    } else {
                                      null;
                                    };
                                                
                                                
