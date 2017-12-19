# Template to load standard parameters for all VOs
#
# This template is normally called by vo/config.tpl and should not be called
# directly, except for machines requiring VO parameters being loaded but
# without a real VO configuration (e.g. BDII).

template vo/init;

@{
desc = when true, accounts present on a machine but not part of the Quattor configuration (or of the list of accounts\
 which must be preserved) are deleted. Despite the default value is false for backward compatibility, it is\
 recommended to set this variable to true if possible.
values = true or false
default = false
required = no
}
variable ACCOUNTS_REMOVE_UNKNOWN ?= false;


variable VOS_ACCOUNT_PREFIX_TEMPLATE ?= 'vo/site/vos_account_prefix';
variable VOS_BASE_UID_TEMPLATE ?= 'vo/site/vos_base_uids';
variable VOS_BASE_GID_TEMPLATE ?= 'vo/site/vos_base_gids';
variable VOS_ALIASES_TEMPLATE ?= 'vo/site/aliases';

include { if_exists(VOS_ACCOUNT_PREFIX_TEMPLATE) };
include { if_exists(VOS_BASE_UID_TEMPLATE) };
include { if_exists(VOS_BASE_GID_TEMPLATE) };
# Normally already done in config.tpl when this template is called from it.
include { if_exists(VOS_ALIASES_TEMPLATE) };

variable VOS_ACCOUNT_PREFIX ?= nlist();
variable VOS_BASE_UID ?= nlist();
variable VOS_BASE_GID ?= nlist();
variable VOS_ALIASES ?= nlist();

include { 'vo/functions' };


# Should be explicitly defined in calling template when accounts are needed.
# Default values defined here are not very important as they are normally not used.
# They are just required to exist to allow successful loading of VO parameters
# on machines without a real VO configuration (e.g. BDII).
# Just take care that default values defined here don't conflict with what is
# expected by other VO configuration templates.
variable CREATE_HOME ?= undef;
variable POOL_DIGITS ?= 3;
variable CREATE_KEYS ?= false;
variable POOL_DIGITS ?= 3;
variable INFO_PATH ?= "/opt/edg/var/info";
variable VO_SGM_SUFFIX ?= 's';
variable VO_PROD_SUFFIX ?= 'p';
variable VO_ACCOUNT_SHELL ?= '/bin/bash';
variable VO_GRIDMAPFILE_MAP_VOMS_ROLES ?= false;


variable VO_PARAMS ?={
  foreach(k;v;VOS) {
    if ( exists(VOS_ALIASES[v]) && is_defined(VOS_ALIASES[v]) ) {
      vo = VOS_ALIASES[v];
    } else {
      vo = v;
    };
    SELF[v] = create("vo/params/"+vo);
  };
  SELF;
};

variable VO_INFO = {
  foreach(k;v;VOS) {
    SELF[v] = add_vo_infos(v);
  };
  SELF;
};


# Update VO_SW_AREAS with default SW areas created by add_vo_infos
variable VO_SW_AREAS = {
  foreach(k;v;VOS) {
    if ( exists(VO_INFO[v]['swarea']['name']) ) {
      SELF[v] = VO_INFO[v]['swarea']['name'];
    };
  };
  SELF;
};

# This variable is true if home directories are on a shared filesystem
# Consider that all the VOs have the same configuration.
variable CE_SHARED_HOMES ?= {
  shared_homes = false;
  foreach(k;v;VO_INFO) {
    if ( exists(v['shared_homes']) && is_defined (v['shared_homes']) && v['shared_homes']) {
      shared_homes = true;
    };
  };
  shared_homes;
};

# Configure ncm-accounts to preserve or remove unknown accounts based on ACOUNTS_REMOVE_UNKNOWN.
# Not that this setting affects all accounts present on the machine, not just the VO accounts.
'/software/components/accounts/remove_unknown' = ACCOUNTS_REMOVE_UNKNOWN;
