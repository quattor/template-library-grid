unique template features/htcondor/params;

@{
desc = CONDOR_CONFIG is used to manage configuration information about HTCondor
}

variable CONDOR_CONFIG = {
    # Default Central Manager is LRMS_SERVER_HOST
    if (!is_defined(SELF['host'])) {
        SELF['host'] = LRMS_SERVER_HOST;
    };

    # Default domain name is grid
    if (!is_defined(SELF['domain'])) {
        SELF['domain'] = 'grid';
    };

    # Condor version is used to a RPM packaging change in condor 8.3
    if (!is_defined(SELF['version'])) {
        SELF['version'] = '8.4';
    };

    if (!is_defined(SELF['pwd_hash'])) {
        error("Missing 'pwd_hash' attribute of CONDOR_CONFIG.\n");
    };

    if (!is_defined(SELF['pwd_file'])) {
        SELF['pwd_file'] = '/var/lib/condor/condor_credential';
    };

    if (!is_defined(SELF['cfgdir'])) {
        SELF['cfgdir'] = '/etc/condor';
    };

    if (!is_defined(SELF['cfgprefix'])) {
        SELF['cfgprefix'] = 'quattor';
    };

    # Default, all other file under SELF['cfgdir']/config.d will be removed
    if (!is_defined(SELF['strict'])) {
        SELF['strict'] = true;
    };

    if (!is_defined(SELF['restart'])) {
        if ( SELF['strict']) {
            enforce = SELF['cfgdir'] + '/quattor_cleaning_script.sh';
        } else {
            enforce = 'exit 0';
        };

        SELF['restart'] = '(' + enforce + ')&&(!(service condor status) || condor_reconfig)';
    };

    if (!is_defined(SELF['cfgfiles'])) {
        SELF['cfgfiles'] = list();
    };

    foreach (i; file; SELF['cfgfiles']) {
        if (!is_defined(file['name'])) {
            error('No attribute "name" defined for CONDOR_CONFIG["cfgfiles"]["' + to_string(i) + '"]');
        };

        if (!is_defined(file['path'])) {
            file['path'] = SELF['cfgdir'] + '/config.d/' + SELF['cfgprefix'] + '.' + to_string(i) + '.' + file['name'] + '.conf';
        };

        if (!is_defined(file['contents'])) {
            error('No attribute "contents" defined for CONDOR_CONFIG["cfgfiles"]["' + to_string(i) + '"]');
        };

        if (!is_defined(file['restart'])) {
            file['restart'] = SELF['restart'];
        };
    };

    #Default config local file is empty
    if (!is_defined(SELF['config.local'])) {
        SELF['config.local'] = '';
    };

    # Default configuration is *not* enable Multicore
    if (!is_defined(SELF['multicore'])) {
        SELF['multicore'] = false;
    };

    # Default configuration is *not* enable GPU's detection
    if (!is_defined(SELF['gpu'])) {
        SELF['gpu'] = false;
    };

    # Default configuration is *not* enable Intel MIC detection
    if (!is_defined(SELF['intel_mic'])) {
        SELF['intel_mic'] = false;
    };

    # Default MaxVacateTime (48 * 60 * 60)
    if (!is_defined(SELF['maxvacatetime'])) {
        SELF['maxvacatetime'] = 48 * 60 * 60 * 100;
    };

    # Default wallclocktime for all jobs
    if (!is_defined(SELF['wctlimit'])) {
        SELF['wctlimit'] = 0;
    };

    # Default allow all machine under SITE_DOMAIN
    if (!is_defined(SELF['allow'])) {
        SELF['allow'] = "*." + SITE_DOMAIN;
    };
    SELF;
};

