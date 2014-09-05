unique template features/gsissh/server/config;

variable GSISSH_PORT ?= 1975;

include { 'features/gsissh/server/rpms' };

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

include { 'components/metaconfig/config' };

prefix '/software/components/metaconfig/services/{/etc/gsissh/sshd_config}';
'mode'     = 0644;
'owner'    = 'root';
'group'    = 'root';
'module'   = 'general';
'contents/Port'                            = GSISSH_PORT;
'contents/PermitRootLogin'                 = 'no';
'contents/RSAAuthentication'               = 'no';
'contents/PubkeyAuthentication'            = 'no';
'contents/PasswordAuthentication'          = 'no';
'contents/ChallengeResponseAuthentication' = 'no';

prefix '/software/components/metaconfig/services/{/etc/grid-security/gsi-authz.conf}';

'mode'   = 0644;
'owner'  = 'root';
'group'  = 'root';
'module' = 'general';
'contents/globus_mapping' = '/usr/lib64/liblcas_lcmaps_gt4_mapping.so lcmaps_callout';
