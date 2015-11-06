unique template features/wlcg/config;

# HEP dependencies
variable HEP_OSLIBS ?= true;

variable HEP_OSLIBS_MAPPING ?= dict(
    'sl5', 'HEP_OSlibs_SL5',
    'sl6', 'HEP_OSlibs_SL6',
    'el7', 'HEP_OSlibs_SL7',
);

"/software/packages" = {
  if (HEP_OSLIBS) {
    if (exists(HEP_OSLIBS_MAPPING[OS_VERSION_PARAMS['major']])) {
      pkg_repl(HEP_OSLIBS_MAPPING[OS_VERSION_PARAMS['major']]);
    } else {
      error(format('No HEP_OSlibs mapping defined for an OS whose major version is %s.',OS_VERSION_PARAMS['major']));
    };
  };
};
