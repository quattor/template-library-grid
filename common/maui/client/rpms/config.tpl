unique template common/maui/client/rpms/config;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;
variable MAUI_VERSION_USED ?= if (is_defined(MAUI_VERSION)) {
	MAUI_VERSION;
} else {
 '3.3-4.el5';
};

# Base RPMs
include  { 'common/maui/client/rpms/' + PKG_ARCH_TORQUE_MAUI + '/config' };

# Update RPMs
include  { 'common/maui/update/rpms/' + PKG_ARCH_TORQUE_MAUI + '/config' };


