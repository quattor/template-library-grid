unique template features/htcondor/client/ce;

variable CONDOR_CONFIG = {
    if (FULL_HOSTNAME == LRMS_SERVER_HOST) {
        file_list = list('submit');
    } else {
        file_list = list('params', 'submit')
    };

    foreach (i; file; file_list) {
        num = length( SELF['cfgfiles']);
        SELF['cfgfiles'][num] = dict( 'name', file, 'contents', 'features/htcondor/templ/' + file);
    };

    if (!is_defined(SELF['options']['submit'])) {
        SELF['options']['submit'] = dict();
    };

    SELF;
};


include 'features/htcondor/server/groups';
include 'features/htcondor/client/policies';
include 'features/htcondor/client/job-transform';

variable CE_QUEUES ?= dict(
    'vos', dict(
        'default', VOS,
    ),
);

include if(CE_FLAVOR == 'condorce') 'features/htcondor/client/condorce/config';
include if(CE_FLAVOR == 'cream') 'features/htcondor/client/creamce';
