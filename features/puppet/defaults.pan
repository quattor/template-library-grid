template features/puppet/defaults;

include 'quattor/functions/package';

include 'components/puppet/config';

variable PUPPET_FULLVERSION = {
    version = if (is_defined(PUPPET_VERSION)) PUPPET_VERSION else '3.0.0';
    version = replace('^([0-9]+)$', '$1.0', version); #Pad single to double
    version = replace('^([0-9]+\.[0-9]+)$', '$1.0', version); # Pad double to triple
    version;
};

include if (pkg_compare_version(PUPPET_FULLVERSION, '4.0.0') != PKG_VERSION_LESS) 'features/puppet/defaults_4+';
include if (pkg_compare_version(PUPPET_FULLVERSION, '5.0.0') != PKG_VERSION_LESS) 'features/puppet/defaults_5+';
