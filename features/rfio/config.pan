
unique template features/rfio/config;

variable RFIO_ENABLED ?= false;
variable RFIO_PORT ?= 5001;

# ---------------------------------------------------------------------------- 
# chkconfig
# ---------------------------------------------------------------------------- 
include { 'components/chkconfig/config' };

"/software/components/chkconfig/service/rfiod" = {
  if (RFIO_ENABLED) {
    tbl = nlist("on","");
  } else {
    tbl = nlist("off","");
  };
  tbl;
};


# ---------------------------------------------------------------------------- 
# accounts
# ---------------------------------------------------------------------------- 
include { 'users/stage' };


# ---------------------------------------------------------------------------- 
# iptables
# ---------------------------------------------------------------------------- 
include { 'components/iptables/config' };

# Inbound port(s).
"/software/components/iptables/filter/rules" = push_if(RFIO_ENABLED,
  nlist("command", "-A",
        "chain", "input",
        "match", "state",
        "state", "NEW",
        "protocol", "tcp",
        "dst_port", to_string(RFIO_PORT),
        "target", "accept"));

# Outbound port(s).


# ---------------------------------------------------------------------------- 
# etcservices
# ---------------------------------------------------------------------------- 
include { 'components/etcservices/config' };

"/software/components/etcservices/entries" = 
  push("rfio "+to_string(RFIO_PORT)+"/tcp");
"/software/components/etcservices/entries" = 
  push("rfio "+to_string(RFIO_PORT)+"/udp");


# ---------------------------------------------------------------------------- 
# cron
# ---------------------------------------------------------------------------- 
#include { 'components/cron/config' };


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
#include { 'components/altlogrotate/config' }; 

