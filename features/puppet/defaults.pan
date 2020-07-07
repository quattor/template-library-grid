template features/puppet/defaults;

include 'quattor/functions/package';

include 'components/puppet/config';

variable PUPPET_FULLVERSION = {
    version = if (is_defined(PUPPET_VERSION)) PUPPET_VERSION else '3.0.0';
    version = replace('^([0-9]+)$', '$1.0', version); #Pad single to double
    version = replace('^([0-9]+\.[0-9]+)$', '$1.0', version); # Pad double to triple
    version;
};

variable PUPPET_INCLUDE = {
    if (pkg_compare_version(PUPPET_FULLVERSION, '6.0.0') <= 0) {
        'features/puppet/defaults_6+';
    } else if (pkg_compare_version(PUPPET_FULLVERSION, '5.0.0') <= 0) {
        'features/puppet/defaults_5+';
    } else if (pkg_compare_version(PUPPET_FULLVERSION, '4.0.0') <= 0) {
        'features/puppet/defaults_4+';
    } else {
        null;
    }
};

include PUPPET_INCLUDE;
