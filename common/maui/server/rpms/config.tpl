unique template common/maui/server/rpms/config;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;
variable MAUI_VERSION_USED ?= if (is_defined(MAUI_VERSION)) { 
        MAUI_VERSION;
} else {
 '3.3-4.el5';
};

variable INFO_DYNAMIC_MAUI_VERSION ?= '2.0.9-1';

# Base RPMs
include  { 'common/maui/server/rpms/' + PKG_ARCH_TORQUE_MAUI + '/config' };

# GIP plugin for CE according to GIP_CE_USE_MAUI variable
'/software/packages' = if (  GIP_CE_USE_MAUI ) {
                         pkg_repl('lcg-info-dynamic-maui',INFO_DYNAMIC_MAUI_VERSION,'noarch');  
                         pkg_repl('python-pbs','4.3.0-5.el5',PKG_ARCH_TORQUE_MAUI);
                         pkg_repl('dynsched-generic','2.4.1-1.sl5','noarch');
                       } else {
                         return(SELF);
                       };


# Update RPMs
include  { 'common/maui/update/rpms/' + PKG_ARCH_TORQUE_MAUI + '/config' };


