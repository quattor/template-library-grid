unique template features/htcondor/server/service;

variable CONDOR_CONFIG = {
    # Define the appropriate config files
    if (!is_defined(SELF['cfgfiles'])) {
        SELF['cfgfiles'] = list();
    };

    file_list = list('global', 'security', 'params', 'head');

    if (is_defined(SELF['multicore']) && SELF['multicore']) {
        file_list[length(file_list)] = 'defrag';
    };

    if (is_defined(SELF['ganglia']) && SELF['ganglia']) {
        file_list[length(file_list)] = 'ganglia';
    };

    if (is_defined(SELF['had']) && SELF['had']) {
        file_list[length(file_list)] = 'had';
    };

    foreach (i; file; file_list) {
        num = length( SELF['cfgfiles']);
        SELF['cfgfiles'][num] = dict(
            'name', file,
            'contents', 'features/htcondor/templ/' + file
        );
    };

    if (!is_defined(SELF['options']['head'])) {
        SELF['options']['head'] = dict();
    };

    SELF;
};

include 'features/htcondor/server/groups';
include 'features/htcondor/client/policies';


# By default all VO has same queue named https://cream.domain.org:7443/cream-condor-default
variable CE_QUEUES ?= {
    SELF['vos']['default'] = VOS;
    SELF;
};

# If current machine is CREAM-CE
include if (index(FULL_HOSTNAME, CE_HOSTS) >= 0) 'features/htcondor/client/ce';

include 'features/htcondor/config';

# CONDOR_HOST is mandatory for GIP configuration
variable CONDOR_HOST = CONDOR_CONFIG['host'];

