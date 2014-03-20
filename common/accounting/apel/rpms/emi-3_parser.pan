unique template common/accounting/apel/rpms/emi-3_parser;

include { 'config/emi/3.0/apel' };

# Remove metapackage since it requires the old parser
'/software/packages/{emi-cream-ce}' = null;

#
# APEL parsers from EMI-3
#
# WARNING
# WARNING: this won't get updated by updates/errata, it will need manual maintenance
# WARNING
#
'/software/packages' = pkg_repl('apel-lib', '1.1.3-0.el' + OS_VERSION_PARAMS['majorversion'], 'noarch');
'/software/packages' = pkg_repl('apel-parsers', '1.1.3-0.el' + OS_VERSION_PARAMS['majorversion'], 'noarch');
'/software/packages' = pkg_repl('python-iso8601', '0.1.4-2.el' + OS_VERSION_PARAMS['majorversion'], 'noarch');

# 
# ncm-metaconfig dependencies
#
'/software/packages' = pkg_repl('perl-Config-Tiny', '2.10-1.el' + OS_VERSION_PARAMS['majorversion'], 'noarch');
'/software/packages' = pkg_repl('perl-Readonly', '1.03-6.el' + OS_VERSION_PARAMS['majorversion'], 'noarch');
'/software/packages' = pkg_repl('perl-Readonly-XS', '1.04-7.el' + OS_VERSION_PARAMS['majorversion'] + '.1', 'x86_64');
'/software/packages' = pkg_repl('perl-YAML-LibYAML', '0.34-1.el' + OS_VERSION_PARAMS['majorversion'] + '.rf', 'x86_64');
