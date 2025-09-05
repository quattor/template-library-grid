# Template doing configuration common to Torque client and server,
# mainly ssh config.

unique template features/torque2/config;

variable TORQUE_CLIENT_MOM_ENABLED ?= true;
variable TORQUE_SERVER_HOST ?= LRMS_SERVER_HOST;
variable TORQUE_SERVER_PRIV_HOST ?= if ( exists(CE_PRIV_HOST) ) {
    CE_PRIV_HOST;
} else {
    undef;
};

# Directory where configuration/working directories are located
variable TORQUE_CONFIG_DIR ?= '/var/torque';

# ----------------------------------------------------------------------------
# etcservices
# ----------------------------------------------------------------------------
include 'components/etcservices/config';

"/software/components/etcservices/entries" = push("pbs 15001/tcp");
"/software/components/etcservices/entries" = push("pbs_mom 15002/tcp");
"/software/components/etcservices/entries" = push("pbs_resmom 15003/tcp");
"/software/components/etcservices/entries" = push("pbs_resmom 15003/udp");
"/software/components/etcservices/entries" = push("pbs_sched 15004/tcp");


# ---------------------------------------------------------------------------- 
# pbsclient (masters must be defined on the server too).
# ---------------------------------------------------------------------------- 
include 'components/pbsclient/config';
"/software/components/pbsclient/masters" = if ( is_defined(TORQUE_SERVER_PRIV_HOST) ) {
    list(TORQUE_SERVER_PRIV_HOST);
} else {
    list(TORQUE_SERVER_HOST);
};

"/software/components/pbsclient/configPath" = 'mom_priv/config';


# ----------------------------------------------------------------------------
# Configure ssh for communication between CE and WNs
# ----------------------------------------------------------------------------
include if ( TORQUE_CLIENT_MOM_ENABLED ) 'features/ssh/ce';


# ----------------------------------------------------------------------------
# Create PBS monitoring script (cron installed as part of server or client config.
# Define PBS_MONITORING_TEMPLATE to null to suppress installation of this script.
#-----------------------------------------------------------------------------
variable PBS_MONITORING_TEMPLATE ?= if ( is_null(PBS_MONITORING_TEMPLATE) ) {
    null;
} else {
    'features/torque2/pbs-monitoring';
};

variable DEBUG = debug('PBS_MONITORING_TEMPLATE=' + to_string(PBS_MONITORING_TEMPLATE));
include PBS_MONITORING_TEMPLATE;
