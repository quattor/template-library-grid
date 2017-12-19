# This template installs and configures Torque client commands without
# configuring pbs_mom. It is intended to be used on machines needing
# access to Torque config without being a WN, like VO boxes.

unique template features/torque2/client/client-only;

variable TORQUE_VERSION ?= if(OS_VERSION_PARAMS['major'] == 'sl5'){
                                '2.5.9-1.cri';
                           }else{
                                '2.5.9-1.cri.el6';
                           };

variable TORQUE_CLIENT_MOM_ENABLED ?= false;
variable PBS_MONITORING_TEMPLATE ?= null;

# Add RPMs
include { 'features/torque2/client/rpms/config' };


# include configuration common to client and server
include { 'features/torque2/config' };

# ----------------------------------------------------------------------------
# Configuring munge
# ----------------------------------------------------------------------------

include { 'features/torque2/munge/config' };

# ----------------------------------------------------------------------------
# pbsclient
# ----------------------------------------------------------------------------
include { 'components/pbsclient/config' };
"/software/components/pbsclient/behaviour" = "OpenPBS";
"/software/components/pbsclient/restricted" = list(TORQUE_SERVER_HOST);
"/software/components/pbsclient/logEvent" = 255;

