unique template features/wlcg/config;

@{
desc = add libraries required by WLCG applications
values = boolean
required = no
default = true
}
variable HEP_OSLIBS ?= true;

variable HEP_OSLIBS_MAPPING ?= dict(
    'sl5', 'HEP_OSlibs_SL5',
    'sl6', 'HEP_OSlibs_SL6',
    'el7', 'HEP_OSlibs',
);

"/software/packages" = {
    if ( HEP_OSLIBS ) {
        if ( is_defined(HEP_OSLIBS_MAPPING[OS_VERSION_PARAMS['major']]) ) {
            pkg_repl(HEP_OSLIBS_MAPPING[OS_VERSION_PARAMS['major']]);
        } else {
            error(format('No HEP_OSlibs mapping defined for an OS whose major version is %s.', OS_VERSION_PARAMS['major']));
        };
    };
    SELF;
};
