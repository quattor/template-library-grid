unique template features/htcondor/client/worker;

variable CONDOR_CONFIG = {
    file_list = list('worker');
    if (is_defined(SELF['gpu']) && SELF['gpu']) {
        append(file_list, 'gpu')
    };

    if (is_defined(SELF['intel_mic']) && SELF['intel_mic']) {
        append(file_list, 'mic')
    };


    # User wrapper is required by the condorce config (for getting the env)
    # we leave the possibility to change it or disable it.
    if(!is_defined(SELF['use_user_wrapper']))
        SELF['use_user_wrapper'] = true;

    if (SELF['use_user_wrapper'] || is_defined(SELF['user_wrapper'])){
        if(!is_defined(SELF['user_wrapper']))
            SELF['user_wrapper'] = dict();

        if(!is_defined(SELF['user_wrapper']['path']))
            SELF['user_wrapper']['path'] = '/etc/condor/user_wrapper.sh';

        if(!is_defined(SELF['user_wrapper']['templ']))
            SELF['user_wrapper']['templ'] = 'features/htcondor/templ/user_wrapper.sh';

        if(!is_defined(SELF['user_wrapper']['contents']))
            SELF['user_wrapper']['contents'] = file_contents(SELF['user_wrapper']['templ']);
    };


    foreach (i; file; file_list) {
        num = length( SELF['cfgfiles']);
        SELF['cfgfiles'][num] = dict(
            'name', file,
            'contents', 'features/htcondor/templ/' + file
        );
    };

    if (!is_defined(SELF['options']['worker'])) {
        SELF['options']['worker'] = dict();
    };

    SELF;
};

include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    if(is_defined(CONDOR_CONFIG['user_wrapper']))
        SELF[escape(CONDOR_CONFIG['user_wrapper']['path'])] = dict(
            'config', CONDOR_CONFIG['user_wrapper']['contents'],
            'perms', '0755',
        );

    SELF;
};
