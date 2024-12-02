unique template personality/ui/rpms/config;

# EMI UI
"/software/packages" = {
    if (OS_VERSION_PARAMS['major'] == 'sl6') {
        pkg_repl('emi-ui');
    } else {
        pkg_repl('ui');
    };

    SELF;
};
