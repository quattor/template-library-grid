unique template common/gsissh/client/rpms/sl5;

include {'components/spma/functions'};
'/software/packages' = pkg_repl('gsi-openssh', '4.3p2-5.el5', PKG_ARCH_DEFAULT);
'/software/packages' = pkg_repl('gsi-openssh-clients', '4.3p2-5.el5', PKG_ARCH_DEFAULT);
