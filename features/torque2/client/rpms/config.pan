unique template features/torque2/client/rpms/config;

variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;
variable TORQUE_CLIENT_MOM_ENABLED ?= true;

prefix '/software/packages';

'{emi-version}' ?= nlist();
'{glite-yaim-torque-client}' ?= nlist();
'{lcg-pbs-utils}' ?= nlist();
'{libtorque}' ?= nlist();
'{munge}' ?= nlist();
'{munge-libs}' ?= nlist();
'{torque}' ?= nlist();
'{torque-client}' ?= nlist();
'{torque-mom}' ?= nlist();
