unique template common/torque2/server/rpms/config;

# Can be set to false for a pure Torque server
variable TORQUE_GLITE ?= true;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;

# Base RPMs
include  { 'common/torque2/server/rpms/' + PKG_ARCH_TORQUE_MAUI + '/config' };

# Update RPMs
#ANDREA: for the moment hardcoding the sl5 repo
include  { 'common/torque2/update/rpms/sl5/' + PKG_ARCH_TORQUE_MAUI + '/config' };

# Add  gLite tools for Torque
##'/software/packages' = if ( TORQUE_GLITE ) {
##                         # If a CE is running on the same machine, add Torque metapackage
##                         if ( is_defined(CE_FLAVOR) ) {
##                           if ( (CE_FLAVOR == 'lcg') || (CE_FLAVOR == 'cream') ) {
##                             pkg_repl("emi-torque-server","1.0.0-2.sl5","x86_64");
##                           } else {
##                             error('Unsupported CE flavor ('+CE_FLAVOR+')');
##                           };
##                         };
#                         pkg_repl("lcg-pbs-utils","2.0.0-1.sl5","x86_64");
#                        pkg_repl("glite-yaim-torque-server","5.1.0-1.sl5","noarch");
#                         pkg_repl("glite-yaim-torque-utils","5.1.1-2.sl5","noarch");
#			 pkg_repl('glite-info-templates','1.0.0-8','noarch');  #NOT FOUND
#			 pkg_repl('glite-info-generic','2.0.2-3','noarch');    #NOT FOUND
#			 pkg_repl("lcg-info-dynamic-scheduler-generic","2.3.5-1.sl5","noarch");
'/software/packages'= {
  pkg_repl("lcg-info-dynamic-scheduler-pbs","2.4.1-4.sl5","noarch");
  pkg_repl("lcg-info-dynamic-software","1.0.7-1.sl5","noarch");
};
##                       } else {
##                         return(SELF);
##                       };

 
