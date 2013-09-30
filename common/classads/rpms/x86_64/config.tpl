unique template common/classads/rpms/x86_64/config;

#'/software/packages' = pkg_repl('classads', '1.0-2.sl5', 'x86_64')
'/software/packages' = pkg_repl('jclassads', '2.4.0-2.'+OS_VERSION_PARAMS['major'], 'noarch');