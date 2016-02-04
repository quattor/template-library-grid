@{
 Standard repositories to use for deploying HTCondor.
 Two repositories are available: the stable version and the development version that
 tends to be the most used one... Only one needs to be added.
}

unique template repository/config/htcondor;

include { 'quattor/functions/repository' };

@{
desc =  if true, use devel repository instead of stable
values = true or false
default = false
required = no
}
variable REPOSITORY_HTCONDOR_DEVEL_ENABLED ?= false;

variable YUM_SNAPSHOT_NS ?= 'repository/snapshot';
variable YUM_HTCONDOR_SNAPSHOT_NS ?= YUM_SNAPSHOT_NS;

@{
desc = HTCondor YUM repository name
values = string
default = depends on REPOSITORY_HTCONDOR_DEVEL_ENABLED and OS version (see below)
required = no
}
variable HTCONDOR_YUM_REPOSITORY_NAME ?= {
    if ( REPOSITORY_HTCONDOR_DEVEL_ENABLED ) {
      condor_devel = 'devel_';
    } else {
      condor_devel = '';
    };
    format('htcondor_%s%s',condor_devel,OS_VERSION_PARAMS['major']);
};

@{
desc =  YUM snapshot date to use for  HTCondor
values =  string matching a YUM snapshot at site (typically YYYYMMDD) or null to disable usage of a YUM snapshot
default = YUM_SNAPSHOT_DATE
required = no
}
variable YUM_HTCONDOR_SNAPSHOT_DATE ?= if ( is_null(YUM_HTCONDOR_SNAPSHOT_DATE) ) {
                                       debug(format('%s: YUM_HTCONDOR_SNAPSHOT_DATE set to null, ignoring YUM snapshot',OBJECT));
                                       SELF;
                                     } else if ( is_defined(YUM_SNAPSHOT_DATE) ) {
                                       debug(format('%s: YUM_HTCONDOR_SNAPSHOT_DATE undefined, using YUM_SNAPSHOT_DATE (%s)',OBJECT,YUM_SNAPSHOT_DATE));
                                       YUM_SNAPSHOT_DATE;
                                     } else {
                                       debug(format('%s: YUM_HTCONDOR_SNAPSHOT_DATE undefined, ignoring YUM snapshot',OBJECT));
                                       undef;
                                     };

@{
desc =  list of repository to load specified as a list of templates describing the repositories
values = list of strings, each string being a template name. Non existing templates will be ignored. \
 If null, no repository will be added.
default = htcondor
required = no
}
include { 'repository/config/quattor' };
variable YUM_HTCONDOR_REPOSITORY_LIST ?= {
  if ( !is_null(YUM_HTCONDOR_REPOSITORY_LIST) ) {
    append('htcondor');
  };
};

# If HTCONDOR_REPOSITORY_LIST is undefined, let the site do what is appropriate
'/software/repositories' = if ( is_defined(YUM_HTCONDOR_REPOSITORY_LIST) ) {
                             add_repositories(YUM_HTCONDOR_REPOSITORY_LIST,YUM_HTCONDOR_SNAPSHOT_NS);
                           } else {
                             SELF;
                           };
