unique template features/torque2/client/rpms/config;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;
variable TORQUE_CLIENT_MOM_ENABLED ?= true;

'/software/packages' = {
    pkg_repl('emi-version');
    pkg_repl('glite-yaim-torque-client');
    pkg_repl('libtorque');
    pkg_repl('munge');
    pkg_repl('munge-libs');
    pkg_repl('torque');
    pkg_repl('torque-client');
    pkg_repl('torque-mom');
};
