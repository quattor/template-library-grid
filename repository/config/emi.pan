unique template repository/config/emi;
 
include { 'quattor/functions/repository' };

variable REPOSITORY_EMI_PREFIX ?= 'emi_3_0_' + OS_VERSION_PARAMS['major'] + '_' + PKG_ARCH_DEFAULT;

variable EPEL_REPOSITORY ?= 'epel_' + OS_VERSION_PARAMS['major'] + '_x86_64';

# Ordered list of repository to load
variable EMI_REPOSITORY_LIST = list(
    REPOSITORY_EMI_PREFIX + '_base',
    REPOSITORY_EMI_PREFIX + '_third_party',
    REPOSITORY_EMI_PREFIX + '_updates',
    REPOSITORY_EMI_PREFIX + '_external',
    REPOSITORY_EMI_PREFIX + '_unofficial',
    REPOSITORY_EMI_PREFIX + '_test',
    REPOSITORY_EMI_PREFIX + '_sam',
    'mpi',
    'xrootd',
    'HEP_libs',
    EPEL_REPOSITORY,
);

'/software/repositories' = add_repositories(EMI_REPOSITORY_LIST);
# Hack to ensure that the EPEL repository is the last one in case some
# RPMs are present both in EPEL and EMI-3 with different contents/requirements.
'/software/repositories' = {
  newlist = list();
  foreach (i;rep;SELF) {
    if ( match(rep['name'],EPEL_REPOSITORY) && (i != length(SELF)-1) ) {
      debug("EPEL repository '"+rep['name']+"' removed at position "+to_string(i)+" in repository list");
    } else {
      newlist[length(newlist)] = rep;
    };
  };
  newlist;
};
