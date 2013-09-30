unique template common/torque2/server/rpms/x86_64/config;

include { 'components/spma/config' };

variable TORQUE_USE_PBS_SCHED ?= false;

# Add required RPMs provided by the OS
include { "config/emi/" + EMI_VERSION + "/torque_server" };


# Include Torque client (without MOM)
variable TORQUE_CLIENT_MOM_ENABLED ?= false;
#Andrea: for the moment hardcode sl5 for the server
include { 'common/torque2/client/rpms/sl5/' + PKG_ARCH_TORQUE_MAUI + '/config' };

#RPMs needed fro torque server
'/software/packages'=pkg_repl("emi-torque-server","1.0.0-2.sl5","x86_64");

#TORQUE
"/software/packages"=pkg_repl("torque-server",TORQUE_VERSION,"x86_64");

# For new MAUI-based GIP plugin
'/software/packages' = pkg_repl("python-pbs","4.3.0-5.el5","x86_64");

#GridFTP Servers
"/software/packages"=pkg_repl("glite-initscript-globus-gridftp","1.0.4-1.sl5","noarch");
"/software/packages"=pkg_repl("globus-gridftp-server-progs","6.14-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server","6.14-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gridftp-server-control","2.7-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-xio-gsi-driver","2.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-authz","2.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-ftp-control","4.4-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gfork","3.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-authz-callout-error","2.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-io","9.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-usage","3.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-xio","3.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-xio-pipe-driver","2.2-1.el5","x86_64");

#ANDREA: other dependencies
"/software/packages"=pkg_repl("lrms-python-generic","2.2.1-2.sl5","noarch");
"/software/packages"=pkg_repl("lcas-lcmaps-gt4-interface","0.2.1-4.el5","x86_64");
"/software/packages"=pkg_repl("gridsite-libs","1.7.21-4.el5","x86_64");
"/software/packages"=pkg_repl("glite-info-templates","1.0.0-12","noarch");

"/software/packages"=pkg_repl('glite-yaim-torque-server','5.1.0-1.sl5','noarch');
