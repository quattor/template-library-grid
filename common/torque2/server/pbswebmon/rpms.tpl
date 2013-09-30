unique template common/torque2/server/pbswebmon/rpms;

'/software/packages' = pkg_repl('pbswebmon','0.8.1-1','noarch');
'/software/packages' = pkg_repl('python-pbs','4.3.0-5.el5',PKG_ARCH_TORQUE_MAUI);

