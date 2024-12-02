# Template to configure ssh and sshd on CE and WNs

unique template features/ssh/ce;

variable CE_PBS_KNOWNHOSTS ?= INSTALL_ROOT+'/etc/edg-pbs-knownhosts.conf';

# ----------------------------------------------------------------------------
# Control variables initialization
# -----------------------------------------------------------------------------

# If CE_USE_SSH is undef, check NFS configuration to determine
# if it is required
variable SSH_HOSTBASED_AUTH ?=
  if ( !exists(CE_USE_SSH) || !is_defined(CE_USE_SSH) ) {
    if ( exists(CE_SHARED_HOMES) && is_defined(CE_SHARED_HOMES) && CE_SHARED_HOMES ) {
      return(false);
    } else {
      return(true);
    };
  } else {
    return(CE_USE_SSH);
  };

# Configure also RSH hosts.equiv. Default : false.
# 3 possible values :
#    - true : create hosts.equiv with CE and WNs
#    - false : create an empty hosts.equiv (disable an existing configuration)
#    - undef : don't do anything (keep an existing hosts.equiv)
# There is normally no need to create hosts.equiv.
variable VAR_EXISTS = exists(RSH_HOSTS_EQUIV);
variable RSH_HOSTS_EQUIV ?= if (VAR_EXISTS) {
                              return(RSH_HOSTS_EQUIV);
                            } else {
                              return(false);
                            };

#If true allow hostauthentification for localhost only
variable SSH_HOSTBASED_AUTH_LOCAL ?= false;

# Used to set the value of SSH configuration options in SSH configuration files
variable SSH_HOSTBASED_CONFIG =
  if ( SSH_HOSTBASED_AUTH ) {
    return("yes");
  } else {
    return("no");
  };

# Build list of WNs + CE + TORQUE_SERVER_CLIENTS to be used to produce hosts.equiv and shosts.equiv.
# Set it to an empty list if SSH_HOSTBASED_CONFIG is false.

variable CE_HOST_LIST = {
  value = '';

  # CE hosts
  foreach (i;ce;CE_HOSTS) {
    value = value + ce + "\n";
  };
  if (exists(CE_PRIV_HOST) && is_defined(CE_PRIV_HOST)) {
		value = value + CE_PRIV_HOST + "\n";
  };

  # Worker nodes
  wns = WORKER_NODES;
  ok = first(wns,k,v);
  while (ok) {
    value = value + v + "\n";
    ok = next(wns,k,v);
  };

  # Additional Torque clients
  if (exists(TORQUE_SERVER_CLIENTS) && is_defined(TORQUE_SERVER_CLIENTS)) {
  	torallow = TORQUE_SERVER_CLIENTS;
  	ok = first(torallow,k,v);
  	while (ok) {
    		value = value + v + "\n";
    		ok = next(torallow,k,v);
  	};
  };
  value;
};

variable SHOSTS_EQUIV_LIST =
  if ( SSH_HOSTBASED_AUTH ) {
    return(CE_HOST_LIST);
  } else if ( SSH_HOSTBASED_AUTH_LOCAL ) {
    #return(FULL_HOSTNAME +  "\n" + CE_HOST);
    return(FULL_HOSTNAME);
  } else {
    return("");
  };

# If RSH_HOSTS_EQUIV is false, add at least CEs which are not the LRMS
# master if configuring the LRMS master node.
# This is required for authorizing their use of Torque client commands.
variable HOSTS_EQUIV_LIST = {
  if ( is_defined(RSH_HOSTS_EQUIV) && RSH_HOSTS_EQUIV ) {
    contents = CE_HOST_LIST;
  } else if ( FULL_HOSTNAME == LRMS_SERVER_HOST ) {
    contents = '';
    foreach (i;ce;CE_HOSTS) {
      if ( ce != FULL_HOSTNAME ) {
        contents = contents + ce + "\n";
      };
    };
  } else {
    contents = '';
  };
  contents;
};


# ----------------------------------------------------------------------------
# pbsknownhosts
# -----------------------------------------------------------------------------
include { 'components/pbsknownhosts/config' };
"/software/components/pbsknownhosts/configFile" = CE_PBS_KNOWNHOSTS;

# Add CE explicitly as it is not a PBS node
"/software/components/pbsknownhosts/nodes" = CE_HOST_LIST;
"/software/components/pbsknownhosts/targets" = list("knownhosts");


# ----------------------------------------------------------------------------
# Build SSH client configuration
# ----------------------------------------------------------------------------
include { 'components/filecopy/config' };

variable SSH_HOSTBASED_CONFIG =
 if ((SSH_HOSTBASED_AUTH) || (SSH_HOSTBASED_AUTH_LOCAL)) {
   return("yes");
 } else {
   return("no");
 };

variable CONTENTS = <<EOF;
Host *
Protocol 2,1
   RhostsRSAAuthentication yes
   RSAAuthentication yes
   PasswordAuthentication yes
   EnableSSHKeysign yes
EOF
variable CONTENTS = CONTENTS +
                    "   HostbasedAuthentication " + SSH_HOSTBASED_CONFIG + "\n";


"/software/components/filecopy/services" =
  npush(escape("/etc/ssh/ssh_config"),
        nlist("config", CONTENTS,
              'owner', 'root:root',
              'perms', '0644',
             ),
       );


# ----------------------------------------------------------------------------
# Build SSH server configuration
# ----------------------------------------------------------------------------
include { 'components/filecopy/config' };
include { 'components/ssh/config' };

# Configure ssh for host-based authentication.
"/software/components/ssh/daemon/options" = {
  debug('SSH_DAEMON_SITE_CONFIG='+to_string(SSH_DAEMON_SITE_CONFIG));
  if(is_defined(SSH_DAEMON_SITE_CONFIG) || is_null(SSH_DAEMON_SITE_CONFIG) ) {
    SSH_DAEMON_SITE_CONFIG;
  } else {
        SELF['IgnoreUserKnownHosts'] = 'yes';
        SELF['HostbasedAuthentication'] = SSH_HOSTBASED_CONFIG;
        SELF['IgnoreRhosts'] = 'yes';
        SELF['RhostsRSAAuthentication'] = 'no';
#        SELF['KeepAlive'] = 'yes';
  	SELF;
  };
};

# Create shosts.equiv file.
'/software/components/filecopy/services' =
  npush(escape('/etc/ssh/shosts.equiv'),
        nlist('config', SHOSTS_EQUIV_LIST,
              'owner', 'root:root',
              'perms', '0644',
             ),
         );


# ----------------------------------------------------------------------------
# Create RSH hosts.equiv if requested
# ----------------------------------------------------------------------------

'/software/components/filecopy/services' =
  if ( is_defined(RSH_HOSTS_EQUIV) ) {
    npush(escape('/etc/hosts.equiv'),
      nlist('config', HOSTS_EQUIV_LIST,
            'owner', 'root:root',
            'perms', '0644',
           ),
         );
  } else {
    return(SELF);
  };


# ----------------------------------------------------------------------------
# cron
# ----------------------------------------------------------------------------
include { 'components/cron/config' };

"/software/components/cron/entries" =
  push(nlist(
    "name","edg-pbs-knownhosts",
    "user","root",
    "frequency", "33 */2 * * *",
    "command","/usr/sbin/edg-pbs-knownhosts"));


# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------
include { 'components/altlogrotate/config' };

"/software/components/altlogrotate/entries/edg-pbs-knownhosts" =
  nlist("pattern", "/var/log/edg-pbs-knownhosts.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);

