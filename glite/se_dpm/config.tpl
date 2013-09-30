unique template glite/se_dpm/config;

# Default port numbers for DPM services
variable DPM_PORT ?= 5015;
variable DPNS_PORT ?= 5010;
variable GSIFTP_PORT ?= 2811;
variable RFIO_PORT ?= 5001;
variable XROOTDDISK_PORT ?= 1095;
variable XROOTDHEAD_PORT ?= 1094;
variable SRMV1_PORT ?= 8443;
variable SRMV2_PORT ?= 8444;
variable SRMV2_2_PORT ?= 8446;

# Create and install a cron job to check status of DPM daemons
# configured and to restart them if necessary
variable DPM_CHECKDAEMONS_ENABLED ?= true;
variable DPM_CHECKDAEMONS_INTERVAL ?= 5;       # Minutes

# This variable is an internal table of this template.
# An entry must exists for each DPM service name, else iptables
# will not be configured properly and the service will be unreachable.
# Per service variables must be used to customize the port numbers.
variable DPM_PORTS = nlist(
  'dpm',         DPM_PORT,
  'dpns',        DPNS_PORT,
  'gsiftp',      GSIFTP_PORT,
  'rfio',        RFIO_PORT,
  'xrootddisk',  XROOTDDISK_PORT,
  'xrootdhead',  XROOTDHEAD_PORT,
  'srmv1',       SRMV1_PORT,
  'srmv2',       SRMV2_PORT,
  'srmv22',      SRMV2_2_PORT,
);


# Add site specific configuration, if any.
include { DPM_CONFIG_SITE };

# Other initialization after site configuration has been loaded
variable SEDPM_MONITORING_ENABLED ?= false;
variable DPM_DAV_ENABLED ?= false;

# Configure default request lifetime, used for request table purging.
# Set to null to disable request purging.
variable DPM_REQUEST_MAX_LIFETIME ?= if ( is_null(SELF) ) {
                                       null;
                                     } else {
                                       '6m';
                                     };


# Add account dpmmgr
# User running DPM deamons
variable DPM_USER ?= 'dpmmgr';
include { 'users/' + DPM_USER };
# Normally define by preceding template
variable DPM_GROUP ?= 'dpmmgr';
"/software/components/dpmlfc/options/dpm/user" ?= DPM_USER;
"/software/components/dpmlfc/options/dpm/group" ?= DPM_GROUP;


# Load ncm-dpmlfc and set pre dependency : ncm-accounts need be executed first
# Also ncm-sysconfig must be executed before for dpm-gsiftp (globus-gridftp).
# Define daemon ports to match site parameters
include { 'components/dpmlfc/config' };
# Ideally installDir should use GLITE_LOCATION for during migration to
# EMI GLITE_LOCATION was set to /usr which is not appropriate.
# TO BE FIXED whend GLITE_LOCATION is really the root of all directory used.
"/software/components/dpmlfc/options/dpm/installDir" = {
  if ( INSTALL_ROOT == "" ) {
    install_dir = '/';
  } else {
    install_dir = INSTALL_ROOT;
  };
  install_dir;
};
"/software/components/dpmlfc/dependencies/pre" = push("accounts","sysconfig");


# Define DPM hosts for control protocols
"/software/components/dpmlfc" = {
  if ( is_defined(DPM_HOSTS) ) {
    dpm_host_found = false;
    dpns_host_found = false;
    foreach (service;host_list;DPM_HOSTS) {
      if ( service != 'disk' ) {
        if ( is_list(host_list) && (length(host_list) > 0) ) {
          if ( !is_defined(SELF[service]) ) {
            SELF[service] = nlist();
          };
          foreach(i;host;host_list) {
            if ( is_defined(DPM_SERVICE_PARAMS[service]) ) {
              host_params = DPM_SERVICE_PARAMS[service];
            } else {
              host_params = nlist();
            };
            # In addition to DPM_SERVICE_PARAMS, DPM request max lifetime can be defined
            # with DPM_REQUEST_MAX_LIFETIME. DPM_SERVICE_PARAMS takes precedence.
            if ( (service == 'dpm') && !is_defined(host_params['requestMaxAge']) ) {
              host_params['requestMaxAge'] = DPM_REQUEST_MAX_LIFETIME;
            };
            SELF[service][host] = host_params;
          };
        } else {
          error ("Host list undefined or invalid for DPM service "+service);
        };
      };
    };
  } else {
    error("DPM_HOSTS undefined");
  };
  SELF;
};
variable SEDPM_IS_HEAD_NODE = {
  if ( !is_list(DPM_HOSTS['dpns']) || (length(DPM_HOSTS['dpns']) == 0) ) {
    error("DPNS node undefined: DPM_HOSTS['dpns'] list undefined or empty");
  };
  if ( DPM_HOSTS['dpns'][0] == FULL_HOSTNAME ) {
    true;
  } else {
    false;
  };
};


# Define access protocols and related entries for disk servers. Supported
# access protocols are: gsiftp, rfio, https, xroot.
# RFIO has a special processing because:
#  - This is the DPM internal protocol so RFIO daemon MUST run on every disk server,
#    whether RFIO is used an access protocol or not.
#  - Use of SURL with RFIO requires a RFIO daemon on the head node even though
#    this is not a disk server. 
variable DPM_ACCESS_PROTOCOLS ?= list('gsiftp','rfio');
"/software/components/dpmlfc/options/dpm/accessProtocols" ?= DPM_ACCESS_PROTOCOLS;
"/software/components/dpmlfc/" = {
  if ( is_list(DPM_HOSTS['disk']) && (length(DPM_HOSTS['disk']) > 0) ) {
    access_protocols = DPM_ACCESS_PROTOCOLS;
    if ( index('rfio',DPM_ACCESS_PROTOCOLS) < 0 ) {
      access_protocols[length(access_protocols)] = 'rfio';
    };
    foreach (i;protocol;access_protocols) {
      # https configuration through dpmlfc is not yet supported
      if ( protocol != 'https' ) {
        disk_servers = DPM_HOSTS['disk'];
        if ( (protocol == 'rfio') && (index(DPM_HOSTS['dpns'][0],disk_servers) < 0) ) {
          disk_servers[length(disk_servers)] = DPM_HOSTS['dpns'][0];
        };
        foreach (i;host;disk_servers) {
          if ( is_defined(DPM_SERVICE_PARAMS[protocol]) ) {
            host_params = DPM_SERVICE_PARAMS[protocol];
          } else {
            host_params = nlist();
          };
          if ( !is_defined(SELF[protocol]) ) {
            SELF[protocol] = nlist();
          };
          SELF[protocol][host] = host_params;
        };
      };
    };
  } else {
    error("No disk server defined (DPM_HOSTS['disk'])");
  };
  SELF;
};


# Define variables for main protocols to help with GIP configuration in particular.

variable XROOT_ENABLED = if ( index('xroot',DPM_ACCESS_PROTOCOLS) < 0 ) {
                           false;
                         } else {
                           true;
                         };
variable HTTPS_ENABLED = if ( index('https',DPM_ACCESS_PROTOCOLS) < 0 ) {
                           false;
                         } else {
                           true;
                         };
variable GSIFTP_ENABLED = if ( index('gsiftp',DPM_ACCESS_PROTOCOLS) < 0 ) {
                           false;
                         } else {
                           true;
                         };
variable RFIO_ENABLED = if ( index('rfio',DPM_ACCESS_PROTOCOLS) < 0 ) {
                           false;
                         } else {
                           true;
                         };
variable SRMV1_ENABLED = if ( is_defined(DPM_HOSTS['srmv1']) ) {
                           true;
                         } else {
                           false;
                         };
variable SRMV2_ENABLED = if ( is_defined(DPM_HOSTS['srmv22']) ) {
                           true;
                         } else {
                           false;
                         };


# Configure Xrootd access if needed
include { if ( XROOT_ENABLED ) 'glite/se_dpm/config_xrootd' };


# Define service port numbers to match site parameters if not explicitly defined
"/software/components/dpmlfc" = {
  # Each service is described as a list of nlist. Port option is in the nlist.
  # Entries in DPM config that are not related to service definition will be ignored
  # (no matching entry in DPM_PORTS).
  foreach (service;service_params;SELF) {
    if ( is_defined(DPM_PORTS[service]) ) {
      # Need to iterate over all defined nodes for the service as there is no break statement.
      # This should not have side effect as there should be only one entry per node.
      foreach (node;node_params;service_params) {
        debug('DPM host '+to_string(node)+': defining port to '+to_string(DPM_PORTS[service])+' for service '+to_string(service));
        # Unconditionnaly define service port to match global variable
        SELF[service][node]['port'] = DPM_PORTS[service];
      };
    };
  };

  SELF;
};


# ---------------------------------------------------------------------------- 
# iptables
# ---------------------------------------------------------------------------- 

variable DPM_IPTABLES_RULES ?= {
  if ( !is_null(SELF) ) {
    dpm_config = value('/software/components/dpmlfc');
    # Use an nlist to handle duplicates in case of any (should not)
    port_list = nlist();
  
    # For each element in dpmlfc configuration, check if it is a service (if an
    # entry exists in DPM_PORTS) and, if yes, get the corresponding ports from
    # DPM_PORTS (ports in dpmlfc configuration are set to DPM_PORTS contents) if
    # the service runs on current node.
    foreach (service;port;DPM_PORTS) {
      if ( is_defined(dpm_config[service]) ) {
        foreach (node;params;dpm_config[service]) {
          if ( node == FULL_HOSTNAME ) {
            port_list[escape(to_string(port))] = '';
          };
        };
      };
    };
    
    if ( length(port_list) > 0 ) {
      foreach (port;v;port_list) {
        SELF[length(SELF)] = nlist("command", "-A",
                                   "chain", "input",
                                   "match", "state",
                                   "state", "NEW",
                                   "protocol", "tcp",
                                   "dst_port", unescape(port),
                                   "target", "accept");
      };
    };
  };
  SELF;
};

variable DPM_IPTABLES_INCLUDE = if ( is_defined(DPM_IPTABLES_RULES) && (length(DPM_IPTABLES_RULES) > 0) ) {
                                  'components/iptables/config';
                                } else {
                                  null;
                                };
include { DPM_IPTABLES_INCLUDE };
"/software/components/iptables/filter/rules" = {
  rules = list();
  if ( !is_null(DPM_IPTABLES_INCLUDE) ) {
    rules = merge(rules,DPM_IPTABLES_RULES);
  };
  if ( length(rules) > 0 ) {
    rules;
  } else {
    null;
  };
};

# ----------------------------------------------------------------------------
# Set appropriate ownership/permissions on /etc/grid_security/gridmapdir
# ----------------------------------------------------------------------------

'/software/components/gridmapdir/group' = DPM_GROUP;
'/software/components/gridmapdir/perms' = '0775';

# ----------------------------------------------------------------------------
# Sysconfig file for dpm-gsiftp is not installed by the RPM in /etc/sysconfig,
# as of DPM 1.8.5.
# This works around the problem until it is fixed (ihttps://ggus.eu/tech/ticket_show.php?ticket=90641).
# Initial version of configuration file is created from template provided in RPM.
# Create a template from the provided template and when it is modified, update the actual file: this
# trick is used to prevent a modification loop between filecopy and dpmlfc.
# ----------------------------------------------------------------------------

variable DPM_GSIFTP_SYSCONFIG_FILE = '/etc/sysconfig/dpm-gsiftp';
variable DPM_GSIFTP_SYSCONFIG_TEMPLATE = '/usr/share/dpm-dsi/dpm-gsiftp.sysconfig';
'/software/components/filecopy/dependencies/post' = push('dpmlfc');
include { 'components/filecopy/config' };
'/software/components/dpmlfc/dependencies/pre' = push('filecopy');
'/software/components/filecopy/services' = {
  if ( GSIFTP_ENABLED && (index(FULL_HOSTNAME,DPM_HOSTS['disk']) >= 0) ) {
    SELF[escape(DPM_GSIFTP_SYSCONFIG_FILE+'.templ-quattor')] = nlist('source', DPM_GSIFTP_SYSCONFIG_TEMPLATE,
                                                                     'owner', 'root:root',
                                                                     'perms', '0644',
                                                                     'restart', 'cp '+DPM_GSIFTP_SYSCONFIG_FILE+'.templ-quattor '+DPM_GSIFTP_SYSCONFIG_FILE,
                                                                    );
  };
  SELF;
};


# ----------------------------------------------------------------------------
# Must be done at the very end of the configuration
# ----------------------------------------------------------------------------
include { 'glite/se_dpm/check-dpm-daemons' };

