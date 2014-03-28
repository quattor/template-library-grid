unique template feature/gsissh/server/config;

variable GSISSH_PORT ?= 1975;

include { 'feature/gsissh/server/rpms/config' };

# ---------------------------------------------------------------------------- 
# chkconfig
# Ensure sshd is running too.
# ---------------------------------------------------------------------------- 
include { 'components/chkconfig/config' };
"/software/components/chkconfig/service/gsisshd/on" = ""; 
"/software/components/chkconfig/service/gsisshd/startstop" = true; 
"/software/components/chkconfig/service/sshd/on" = ""; 
"/software/components/chkconfig/service/sshd/startstop" = true; 


# ---------------------------------------------------------------------------- 
# iptables
# ---------------------------------------------------------------------------- 
include { 'components/iptables/config' };
# Inbound port(s).
"/software/components/iptables/filter/rules" = push(
  nlist("command", "-A",
        "chain", "input",
        "match", "state",
        "state", "NEW",
        "protocol", "tcp",
        "dst_port", to_string(GSISSH_PORT),
        "target", "accept"));

# Outbound port(s).


# ---------------------------------------------------------------------------- 
# etcservices
# ---------------------------------------------------------------------------- 
include { 'components/etcservices/config' };
"/software/components/etcservices/entries" = 
    push("gsisshd "+to_string(GSISSH_PORT)+"/tcp"
);


# ---------------------------------------------------------------------------- 
# gsissh
# ---------------------------------------------------------------------------- 
include { 'components/gsissh/config' };
"/software/components/gsissh/globus_location" = GLOBUS_LOCATION;
"/software/components/gsissh/gpt_location" = INSTALL_ROOT+"/gpt";

# Configuration for the server.
"/software/components/gsissh/server/port" = GSISSH_PORT;
"/software/components/gsissh/server/options" = nlist(
    "PermitRootLogin", "no",
    "RSAAuthentication", "no",
    "PubkeyAuthentication", "no",
    "PasswordAuthentication", "no",
    "ChallengeResponseAuthentication", "no",
    "Port", to_string(GSISSH_PORT),
    "GSSAPIAuthentication", "yes",
    "GSSAPICleanupCredentials", "yes",
    "Subsystem", "sftp    "+GLOBUS_LOCATION+"/libexec/sftp-server",
    "X11Forwarding", "yes",
    "LogLevel", "VERBOSE",
);
