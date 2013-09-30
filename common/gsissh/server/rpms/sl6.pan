unique template common/gsissh/server/rpms/sl6;

include {'components/spma/functions'};
'/software/packages' = pkg_repl('gsi-openssh', '5.3p1-7.el6', PKG_ARCH_DEFAULT);
'/software/packages' = pkg_repl('gsi-openssh-clients', '5.3p1-7.el6', PKG_ARCH_DEFAULT);
'/software/packages' = pkg_repl('gsi-openssh-server', '5.3p1-7.el6', PKG_ARCH_DEFAULT);
