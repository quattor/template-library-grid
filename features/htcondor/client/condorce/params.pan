unique template features/htcondor/client/condorce/params;

variable GLITE_LOCATION = '/usr';
variable MKGRIDMAP_BIN ?= '/usr/sbin/';

variable CONDOR_CONFIG = {

    # defining a config dir for the condor-ce
    if(!is_defined(SELF['ce_cfgdir']))
        SELF['ce_cfgdir'] = '/etc/condor-ce';

    if(!is_defined(SELF['router_hook']))
        SELF['router_hook'] = 'features/htcondor/templ/hook.py';

    if(!is_defined(SELF['mapping']))
        SELF['mapping'] = dict();

    if(!is_defined(SELF['cert_dns']) || !is_defined(SELF['cert_dns'][FULL_HOSTNAME]))
        error("Missing certificate DN for " + FULL_HOSTNAME + ": CONDOR_CONFIG['cert_dns']['" + FULL_HOSTNAME + "']");

    # implement some default mapping rules.
    # Note that the rules are written in the file in the lexicographic order
    mapping_defaults = dict(
        '10_daemon', dict(
            'type', 'GSI',
            'regex', '"^' + SELF['cert_dns'][FULL_HOSTNAME] + '$"',
            'result', FULL_HOSTNAME + '@daemon.htcondor.org'
        ),

        '20_mapping', dict(
            'type', 'GSI',
            'regex', '(.*)',
            'result', 'GSS_ASSIST_GRIDMAP'
        ),

        '30_unampped', dict(
            'type', 'GSI',
            'regex', '"(/CN=[-.A-Za-z0-9/= ]+)"',
            'result', '\1@unamapped.htcondor.org'
        ),

        '40_anon', dict(
            'type', 'CLAIMTOBE',
            'regex', '.*',
            'result', 'anonymous@claimtobe'
        ),

        '50_fs', dict(
            'type', 'FS',
            'regex', '(.*)',
            'result', '\1'
        ),

    );

    foreach(i; rule; mapping_defaults)
        if(!is_defined(SELF['mapping'][i]))
            SELF['mapping'][i] = rule;

    SELF;
};
