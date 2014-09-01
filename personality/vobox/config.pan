unique template personality/vobox/config;

# Proxy renewal interval (in hours) and log rotation parameters
variable VOBOX_PROXY_RENEWAL_INTERVAL ?= 6;
variable VOBOX_PROXY_RENEWAL_LOG_FREQUENCY ?= 'monthly';
variable VOBOX_PROXY_RENEWAL_LOG_ROTATION ?= 12;

# TCP parameters for optimal performances
variable VOBOX_TCP_MAX_BUFFER_SIZE ?= 8388608;
variable VOBOX_TCP_MAX_BACKLOG ?= 250000;

# List of directory to create in VO-specific directory.
# The following list is the minimum list: add it to site-specific defaults.
variable VOBOX_VO_DIRS_ROOT ?= INSTALL_ROOT + '/vobox';
variable VOBOX_VO_DIRECTORIES = {
  if ( !is_defined(SELF) || index('start',SELF) < 0 ) {
    SELF[length(SELF)] = 'start';
  };
  if ( index('stop',SELF) < 0 ) {
    SELF[length(SELF)] = 'stop';
  };
  if ( index('agents',SELF) < 0 ) {
    SELF[length(SELF)] = 'agents';
  };
  if ( index('info-provider',SELF) < 0 ) {
    SELF[length(SELF)] = 'info-provider';
  };
  if ( index('log',SELF) < 0 ) {
    SELF[length(SELF)] = 'log';
  };
  if ( index('proxy_repository',SELF) < 0 ) {
    SELF[length(SELF)] = 'proxy_repository';
  };
  SELF;
};


# Retrieve from VO_INFO the VO user enabled for access to VOBOX services.
# Normally there should be only one enabled VO, this has been checked before (personality/vobox/init)
variable VOBOX_ENABLED_VOS_USER ?= {
  foreach (i;vo;VOBOX_ENABLED_VOS) {
    if ( is_defined(VO_INFO[vo]['vobox_user']) ) {
      SELF[vo] = VO_INFO[vo]['vobox_user'];
    } else {
      debug('No FQAN allowed for VO '+vo+'. VOBOX services will not be configured for this vo');
    };
  };
  SELF;
};

# Create directories for each enable VOs
include { 'components/dirperm/config' };
'/software/components/dirperm/paths' = {
  if ( is_defined(VOBOX_ENABLED_VOS_USER) ) {
    foreach (vo;user;VOBOX_ENABLED_VOS_USER) {
      vo_dir_root = VOBOX_VO_DIRS_ROOT+'/'+vo;
      SELF[length(SELF)] = nlist('path', vo_dir_root,
                                 'perm', '0755',
                                 'owner', user,
                                 'type', 'd',
                                );
      foreach (i;dir;VOBOX_VO_DIRECTORIES) {
        SELF[length(SELF)] = nlist('path', vo_dir_root+'/'+dir,
                                   'perm', '0700',
                                   'owner', user,
                                   'type', 'd',
                                  );
      };
    };
  } else {
    debug('No FQAN allowed access to VOBOX services.');
  };
  SELF;
};


# TODO (1/9/2014): configure proxy renewal script supplied by lcg-vobox RPM


# Recommended settings for TCP/IP to improve performances
# cf http://monalisa.cern.ch/FDT/documentation_syssettings.html
include { 'components/sysctl/config' };
"/software/components/sysctl/variables/net.core.rmem_max" = to_string(VOBOX_TCP_MAX_BUFFER_SIZE);
"/software/components/sysctl/variables/net.core.wmem_max" = to_string(VOBOX_TCP_MAX_BUFFER_SIZE);
"/software/components/sysctl/variables/net.ipv4.tcp_rmem"="4096 87380 "+to_string(VOBOX_TCP_MAX_BUFFER_SIZE);
"/software/components/sysctl/variables/net.ipv4.tcp_wmem"="4096 65536 "+to_string(VOBOX_TCP_MAX_BUFFER_SIZE);
"/software/components/sysctl/variables/{net.core.netdev_max_backlog}" = to_string(VOBOX_TCP_MAX_BACKLOG);

# Configuration de gsisshd (gsi-openssh-server)
# En gLite 3.2 la config etait faite par les scripts 
# /opt/globus/setup/gsi_openssh_setup/{setup-openssh,setup-openssh.pl} de
# gsiopenssh-VDT1.10.1x86_64_rhap_5-4.3.x86_64 . Ce RPM n'existe plus ?
# Donc je fais la config par filecopy (/etc/gsissh/sshd_config)

variable GSI_SSHD_CONFIG = <<EOF;
Protocol 2
Port 1975
ChallengeResponseAuthentication no
GSSAPIAuthentication yes
GSSAPICleanupCredentials yes
LogLevel VERBOSE
PasswordAuthentication no
PermitRootLogin no
PubkeyAuthentication no
RSAAuthentication no
Subsystem sftp    /usr/libexec/gsissh/sftp-server
X11Forwarding yes
SyslogFacility AUTHPRIV
EOF

"/software/components/filecopy/services" =
  npush(escape("/etc/gsissh/sshd_config"),
        nlist("config",GSI_SSHD_CONFIG,
              "owner","root",
              "perms","0600"));

