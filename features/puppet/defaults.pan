template features/puppet/defaults;

include 'quattor/functions/package';

include 'components/puppet/config';

variable PUPPET_4_INCLUDE = is_defined(PUPPET_VERSION) &&
    (pkg_compare_version(PUPPET_VERSION, '4.0.0') != PKG_VERSION_LESS);

variable PUPPET_5_INCLUDE = is_defined(PUPPET_VERSION) &&
    (pkg_compare_version(PUPPET_VERSION, '5.0.0') != PKG_VERSION_LESS);

include if (PUPPET_4_INCLUDE) 'features/puppet/defaults_4+';
include if (PUPPET_5_INCLUDE) 'features/puppet/defaults_5+';
