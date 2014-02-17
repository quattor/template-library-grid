unique template common/torque2/client/rpms/config-yd;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;
variable TORQUE_CLIENT_MOM_ENABLED ?= true;

prefix '/software/packages';

'{emi-torque-client}' ?= nlist();
'{munge}' ?= nlist();
'{munge-libs}' ?= nlist();
