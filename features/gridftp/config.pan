
unique template features/gridftp/config;

variable GRIDFTP_PORT = 2811;

# Use this variable to limit the number of simultaneous connections
variable GRIDFTP_MAX_CONNECTIONS ?= 150;

include { 'features/gridftp/rpms/config' };
# ---------------------------------------------------------------------------- 
# chkconfig
# ---------------------------------------------------------------------------- 
include { 'components/chkconfig/config' };

"/software/components/chkconfig/service/globus-gridftp/on" = ""; 


# ---------------------------------------------------------------------------- 
# accounts
# ---------------------------------------------------------------------------- 
include { 'users/gridftp' };


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
        "dst_port", to_string(GRIDFTP_PORT),
        "target", "accept"));

# Outbound port(s).


# ---------------------------------------------------------------------------- 
# etcservices
# ---------------------------------------------------------------------------- 
include { 'components/etcservices/config' };

"/software/components/etcservices/entries" = 
  push("gridftp "+to_string(GRIDFTP_PORT)+"/tcp");


# ---------------------------------------------------------------------------- 
# cron
# ---------------------------------------------------------------------------- 
#include { 'components/cron/config' };


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
#include { 'components/altlogrotate/config' }; 

"/software/components/altlogrotate/entries/gridftp-lcas_lcmaps" =
  nlist("pattern", "/var/log/gridftp-lcas_lcmaps.log",
        "compress", true,
        "missingok", true,
        "frequency", "daily",
        "rotate", 31,
        "sharedscripts", true,
        "create", true,
        "createparams", nlist('mode', '0644', 'owner', 'root', 'group', 'root'),
        );


# ---------------------------------------------------------------------------- 
# globuscfg
# ---------------------------------------------------------------------------- 
include { 'components/globuscfg/config' };

include { 'features/globus/base' };

"/software/components/globuscfg/gridftp/log"= "/var/log/globus-gridftp.log";
"/software/components/globuscfg/gridftp/maxConnections" = {
  if ( is_defined(GRIDFTP_MAX_CONNECTIONS) ) {
    GRIDFTP_MAX_CONNECTIONS;
  } else  if ( is_defined(SELF) ) {
    SELF;
  } else {
    null;
  };
};
"/software/components/globuscfg/services" = push("globus-gridftp");

# work around globuscfg component failure in EMI (some features are now useless)
variable GLOBUSCFG_FIX = <<EOF;
#!/bin/bash
mkdir -p ${GLOBUS_LOCATION:=/usr}/setup/globus

#create empty missing exes wich return 0 so that ncm globuscfg is happy.
for i in setup-tmpdirs setup-globus-common; do
	exe=${GLOBUS_LOCATION}/setup/globus/$i
	if [ ! -f $exe ]; then
		echo "#!/bin/bash" > $exe
		echo "exit 0" >> $exe
		chmod 755 $exe
	fi
done
EOF
variable GLOBUSCFG_FIX_EXE ?= "/usr/sbin/globuscfg_fix";
"/software/components/filecopy/services" =
  npush(escape(GLOBUSCFG_FIX_EXE),
        nlist("config",GLOBUSCFG_FIX,
              "owner","root",
              "perms","0755",
              "restart", GLOBUSCFG_FIX_EXE,
        )
  );

#work around configuration file path, which cannot be specified in globuscfg component
#variable GLOBUS_GRIDFTP_CFGFILE ?= GLOBUS_LOCATION + "/etc/gridftp.conf";  
#"/software/components/symlink/links" =
#  push(nlist("name", GLOBUS_GRIDFTP_CFGFILE,
#             "target", "/etc/gridftp.conf",
#             "replace", nlist("all","yes"),
#       ),
#       #this one also is needed and hardcoded
#       nlist("name", GLOBUS_GRIDFTP_CFGFILE,
#             "target", "/etc/grid-security/gridftp.conf",
#             "replace", nlist("all","yes"),
#       ),
#  );


include 'components/symlink/config';
#work around configuration file path, which cannot be specified in globuscfg component
variable GLOBUS_GRIDFTP_CFGFILE ?= GLOBUS_LOCATION + "/etc/gridftp.conf";

"/software/components/symlink/links" =
  push(nlist("target", GLOBUS_GRIDFTP_CFGFILE,
             "name", "/etc/gridftp.conf",
             "replace", nlist("all","yes"),
       ),
#       #this one also is needed and hardcoded
       nlist("target", GLOBUS_GRIDFTP_CFGFILE,
             "name", "/etc/grid-security/gridftp.conf",
             "replace", nlist("all","yes"),
       ),
  );


