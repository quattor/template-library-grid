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
variable VOBOX_VO_DIRS_ROOT ?= EMI_LOCATION_VAR + '/lib/vobox';
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


# Create proxy renewal script for each supported VO (normally only one)
# and configure related cron and logrotate.
# TODO: when filecopy will have been improved to support regexp-based
# editing of a source file already installed, this will be better to use
# the proxy renewal script installed by the RPM for easier
# synchronisation. But in lcg-vobox 1.0.4-4, the script is so buggy that
# it is unusable as is...

include { 'components/filecopy/config' };
include { 'components/chkconfig/config' };
include { 'components/cron/config' };
include { 'components/altlogrotate/config' };
'/software/components' = {
  if ( !is_defined(SELF['filecopy']['services']) ) {
    SELF['filecopy']['services'] = nlist();
  };
  if ( !is_defined(SELF['chkconfig']['service']) ) {
    SELF['chkconfig']['service'] = nlist();
  };
  if ( !is_defined(SELF['cron']['entries']) ) {
    SELF['cron']['entries'] = list();
  };
  if ( !is_defined(SELF['cron']['allow']) ) {
    SELF['cron']['allow'] = list();
  };
  if ( index('root',SELF['cron']['allow']) < 0 ) {
    SELF['cron']['allow'][length(SELF['cron']['allow'])] = 'root';
  };
  if ( !is_defined(SELF['altlogrotate']['entries']) ) {
    SELF['altlogrotate']['entries'] = nlist();
  };
  if ( index('filecopy',SELF['chkconfig']['dependencies']['pre']) < 0 ) {
    SELF['chkconfig']['dependencies']['pre'][length(SELF['chkconfig']['dependencies']['pre'])] = 'filecopy';
  };
  if ( index('filecopy',SELF['cron']['dependencies']['pre']) < 0 ) {
    SELF['cron']['dependencies']['pre'][length(SELF['cron']['dependencies']['pre'])] = 'filecopy';
  };
  if ( is_defined(VOBOX_ENABLED_VOS_USER) ) {
    foreach (vo;user;VOBOX_ENABLED_VOS_USER) {
      contents = file_contents('personality/vobox/voname-box-proxyrenewal.template');
      contents = replace('(?m:THEVO)',vo,contents);
      contents = replace('(?m:THEADMIN)',user,contents);
      debug("contents = \n"+contents);
      script_name = vo+'-box-proxyrenewal';
      script_path = '/etc/init.d/'+script_name;
      # Add script
      SELF['filecopy']['services'][escape(script_path)] = nlist('config', contents,
                                                                'perms', '0755',
                                                                'restart', '/sbin/service '+script_name+' restart',
                                                               );
      # Restart already handled by filecopy if needed
      SELF['chkconfig']['service'][script_name] = nlist('on', '');
      # Cron entry: also allow the enabled VO user to execute crons.
      # Do not create a log file for the cron as the script already logs
      # actions
      if ( index(user,SELF['cron']['allow']) < 0 ) {
        SELF['cron']['allow'][length(SELF['cron']['allow'])] = user;
      };
      SELF['cron']['entries'][length(SELF['cron']['entries'])] = nlist('name', script_name,
                                                                       'user', 'root',
                                                                       'frequency', 'AUTO 2-23/'+to_string(VOBOX_PROXY_RENEWAL_INTERVAL)+' * * *',
                                                                       'command', '/sbin/service '+script_name+' proxy',
                                                                       'log', nlist('disabled', true),
                                                                      );
      # Logrotate
      SELF['altlogrotate']['entries'][script_name] = 
                                     nlist('pattern', VOBOX_VO_DIRS_ROOT+'/'+vo+'/log/events.log',
                                           'compress', true,
                                           'missingok', true,
                                           'frequency', VOBOX_PROXY_RENEWAL_LOG_FREQUENCY,
                                           'create', true,
                                           'ifempty', true,
                                           'rotate', VOBOX_PROXY_RENEWAL_LOG_ROTATION,
                                          );

    };
  };
  SELF;
};


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

