unique template features/htcondor/client/creamce;

variable CONDOR_CONFIG = {

    if(!is_defined(SELF['queue_superusers_list'])){
        SELF['queue_superusers_list'] = 'tomcat';
    };

    SELF;
};


variable BLPARSER_WITH_UPDATER_NOTIFIER = true;

# Fixme: a bug in the blah RPM
variable HTCONDOR_FIX_BLAH ?= true;
include if(HTCONDOR_FIX_BLAH) 'features/htcondor/client/fix-blah';

include 'components/dirperm/config';

'/software/components/dirperm/paths' = push(
    dict(
        'path', '/var/glite/',
        'type', 'd',
        'owner', 'glite:tomcat',
        'perm', '775'
    )
);

'/software/components/dirperm/paths' = push(
    dict(
        'path', '/var/glite/blah',
        'type', 'd',
        'owner', 'tomcat',
        'perm', '775'
    )
);

include 'components/chkconfig/config';

'/software/components/chkconfig/service/glite-ce-blah-parser' = dict('on', '', 'startstop', true);
