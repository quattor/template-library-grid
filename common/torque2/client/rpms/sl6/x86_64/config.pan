unique template common/torque2/client/rpms/sl6/x86_64/config;

include { 'components/spma/config' };

'/software/packages'=pkg_repl('emi-torque-client',"1.0.0-2.sl6",PKG_ARCH_TORQUE_MAUI);

#RPMs' needed

"/software/packages"=pkg_repl("libtorque",TORQUE_VERSION,"x86_64");
"/software/packages"=pkg_repl("torque",TORQUE_VERSION,"x86_64");
"/software/packages"=pkg_repl("torque-client",TORQUE_VERSION,"x86_64");
"/software/packages"=pkg_repl("torque-mom",TORQUE_VERSION,"x86_64");

"/software/packages"=pkg_repl("lcg-pbs-utils","2.0.0-1.sl6","x86_64");
"/software/packages"=pkg_repl("glite-yaim-torque-utils","5.1.1-2.sl5","noarch");
"/software/packages"=pkg_repl("emi-version","3.0.0-1.sl5","x86_64");

#MUNGE
"/software/packages"=pkg_repl("munge","0.5.10-1.el6","x86_64");
"/software/packages"=pkg_repl("munge-libs","0.5.10-1.el6","x86_64");

# YAIM component for Torque clients
"/software/packages"=pkg_repl("glite-yaim-torque-client","5.1.0-1.sl5","noarch");
