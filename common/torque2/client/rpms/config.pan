unique template common/torque2/client/rpms/config;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;
variable TORQUE_CLIENT_MOM_ENABLED ?= true;

# Base RPMs
include  { 'common/torque2/client/rpms/' + OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_TORQUE_MAUI + '/config' };

# Update RPMs
include  { 'common/torque2/update/rpms/' +  OS_VERSION_PARAMS['major'] + '/' + PKG_ARCH_TORQUE_MAUI + '/config' };


