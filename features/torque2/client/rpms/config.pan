unique template features/torque2/client/rpms/config;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;
variable TORQUE_CLIENT_MOM_ENABLED ?= true;

prefix '/software/packages';

'{emi-version}' ?= dict();
'{glite-yaim-torque-client}' ?= dict();
'{libtorque}' ?= dict();
'{munge}' ?= dict();
'{munge-libs}' ?= dict();
'{torque}' ?= dict();
'{torque-client}' ?= dict();
'{torque-mom}' ?= dict();
