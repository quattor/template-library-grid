unique template repository/config/grid;
 
include { 'quattor/functions/repository' };

variable REPOSITORY_GRID_PREFIX ?= 'emi_3_0_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;


variable YUM_SNAPSHOT_NS ?= 'repository/snapshot';
variable YUM_EMI_SNAPSHOT_NS ?= YUM_SNAPSHOT_NS;

include { 'repository/config/quattor' };

variable EMI_REPOSITORY_LIST ?= {
  SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_base';
  SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_third_party';
  SELF[length(SELF)] = REPOSITORY_GRID_PREFIX + '_updates';
  SELF[length(SELF)] = 'wlcg_x86_64';
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
