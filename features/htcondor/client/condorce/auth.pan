unique template features/htcondor/client/condorce/auth;

variable GLITE_GROUP = 'condor';

variable GRIDMAPDIR_FILES_PERMS = true;

include 'features/security/host_certs';

include 'security/cas';

include 'features/lcmaps/base';

include 'features/lcas/base';

include 'features/fetch-crl/config';

include 'features/mkgridmap/standard';

include 'components/spma/config';
prefix '/software/packages';

'{lcas-lcmaps-gt4-interface}' = dict();

variable CONDORCE_LCMAPS_DEBUG ?= 0;

include 'components/sysconfig/config';
prefix '/software/components/sysconfig/files/condor-ce';

'LCMAPS_DEBUG_LEVEL' = to_string(CONDORCE_LCMAPS_DEBUG);
'LLGT_LIFT_PRIVILEGED_PROTECTION' = '1';
'LCMAPS_LOG_FILE' = '/var/log/glexec/lcmaps.log';
'LCMAPS_DB_FILE' = '/etc/lcmaps/lcmaps.db';
'epilogue' = 'export LCMAPS_DEBUG_LEVEL LCMAPS_LOG_FILE';

include 'components/lcmaps/config';
prefix '/software/components/lcmaps/config/0';

# Just erase everything else. There may be a better way but for the moment this is simpler....
'module' = dict();

'module/vomspoolaccount' = dict(
    "path", "lcmaps_voms_poolaccount.mod",
    "args", "-gridmapfile /etc/lcmaps/gridmapfile " + 
            "-gridmapdir /etc/grid-security/gridmapdir " + 
            "-override_inconsistency " +
            "--add-primary-gid-from-mapped-account "
);

'module/vomslocalgroup' = dict(
    "path", "lcmaps_voms_localgroup.mod",
    "args", "-groupmapfile /etc/lcmaps/groupmapfile " + 
            "-mapmin 0 " + 
            "--map-to-secondary-groups",
);

'module/vomslocalaccount' = dict(
    "path", "lcmaps_voms_localaccount.mod",
    "args", "-gridmapfile /etc/lcmaps/gridmapfile", 
);

'module/good' = dict("path", "lcmaps_dummy_good.mod");

'module/bad' = dict("path", "lcmaps_dummy_bad.mod");

'policies' = list(dict(
    'name', "authorize_only",
    "ruleset", list(
        "vomslocalgroup -> vomslocalaccount",
        "vomslocalaccount -> good | vomspoolaccount",
        "vomspoolaccount -> good|bad",
    ),
));

include 'components/dirperm/config';

prefix '/software/components/dirperm/';

'paths' = push(
    dict('path', '/var/log/glexec',
        'owner', 'condor:condor',
        'perm', '0775',
        'type', 'd'
    )
);

include 'components/filecopy/config';

prefix '/software/components/filecopy/services/{/etc/grid-security/gsi-authz.conf}';

'config' = 'globus_mapping /usr/lib64/liblcas_lcmaps_gt4_mapping.so lcmaps_callout' + "\n";
'restart' = 'service condor-ce restart';
