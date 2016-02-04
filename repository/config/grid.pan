unique template repository/config/grid;
 
include { 'quattor/functions/repository' };

@{
desc = defines the variant of the grid RPM repository to use (typically emi or umd).\
 The full repository template name will be built appending the version, os, arch. 
values = any string
default = emi
required = no
}
variable REPOSITORY_GRID_VARIANT ?= 'emi';
@{
desc = defines the variant of the grid repository to use for third party RPMs (typically emi or umd).\
 This is controlled by a variable distinct from other grid repositories: default should be appropriate.\
 The full repository template name will be built appending the version, os, arch. 
values = any string
default = emi
required = no
}
variable REPOSITORY_GRID_THIRD_PARTY_VARIANT ?= 'emi';
variable REPOSITORY_GRID_PREFIX ?= REPOSITORY_GRID_VARIANT + '_3_0_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;
variable REPOSITORY_GRID_THIRD_PARTY_PREFIX ?= REPOSITORY_GRID_THIRD_PARTY_VARIANT + '_3_0_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

@{
desc = defines the repository to use for WLCG RPMs.
values = any string
default = the default is built by appending 'wlcg', os and arch.
required = no
}
variable REPOSITORY_WLCG ?= 'wlcg_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

variable YUM_SNAPSHOT_NS ?= 'repository/snapshot';
variable YUM_EMI_SNAPSHOT_NS ?= YUM_SNAPSHOT_NS;

variable YUM_EMI_SNAPSHOT_DATE ?= {
  if ( is_defined(YUM_EMI_SNAPSHOT_DATE) && !is_null(YUM_EMI_SNAPSHOT_DATE) ) {
    SELF;
  } else if ( is_defined(YUM_SNAPSHOT_DATE) ) {
    YUM_SNAPSHOT_DATE;
  } else {
    undef;
  };
};

include { 'repository/config/quattor' };

variable EMI_REPOSITORY_LIST ?= {
  SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_base';
  SELF[length(SELF)] = REPOSITORY_GRID_THIRD_PARTY_PREFIX + '_third_party';
  SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_updates';
  SELF[length(SELF)] = REPOSITORY_WLCG;
  SELF[length(SELF)] = 'mpi';
  if ( !is_defined(YUM_SNAPSHOT_DATE) ) {
    SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_external';
    SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_unofficial';
    SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_test';
    SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_sam';
    SELF[length(SELF)] = 'xrootd';
    SELF[length(SELF)] = OS_VERSION_PARAMS['major'] + '_epel';
  };
  SELF;
};

'/software/repositories' = {
  if ( is_defined(YUM_SNAPSHOT_DATE) ) {
    add_repositories(EMI_REPOSITORY_LIST,YUM_EMI_SNAPSHOT_NS);
  } else {
    add_repositories(EMI_REPOSITORY_LIST);
  };
};

# Hack to ensure that the EPEL repository is the last one in case some
# RPMs are present both in EPEL and EMI-3 with different contents/requirements.
'/software/repositories' = {
  if ( !is_defined(YUM_SNAPSHOT_DATE) ) {
    newlist = list();
    foreach (i;rep;SELF) {
      if ( match(rep['name'],'epel') && (i != length(SELF)-1) ) {
        debug("EPEL repository '"+rep['name']+"' removed at position "+to_string(i)+" in repository list");
      } else {
        newlist[length(newlist)] = rep;
      };
    };
    newlist;
  } else {
    SELF;
  };
};
