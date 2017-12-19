unique template personality/lfc/config;

variable LFC_CONFIG_SITE ?= null;

variable LFC_DB_CONFIG_FILE_DEFAULT ?= '/etc/NSCONFIG';

#
# Add site specific configuration, if any
include { LFC_CONFIG_SITE };

# User running LFC deamons (normally created by RPMs)
variable LFC_USER ?= 'lfcmgr';
variable LFC_GROUP ?= LFC_USER;

# Default port numbers for LFC services
variable LFC_PORT ?= 5010;
variable LFC_DLI_PORT ?= 8085;

# Database related variables
variable LFC_DB_NAME ?= 'cns_db';
variable LFC_DB_INIT_SCRIPT ?= '/usr/share/lcgdm/create_lfc_tables_mysql.sql';
variable LFC_MYSQL_SERVER ?= FULL_HOSTNAME;
variable LFC_MYSQL_ADMINUSER_DEFAULT ?= 'root';

# This variable is an internal table of this template.
# An entry must exists for each LFC service name, else iptables
# will not be configured properly and the service will be unreachable.
# Per service variables must be used to customize the port numbers.
variable LFC_PORTS = nlist(
  'lfc',       LFC_PORT,
  'lfc-dli',    LFC_DLI_PORT,
);

# Load ncm-dpmlfc and set pre dependencies : ncm-accounts and ncm-mysql.
# Define daemon ports to match site parameters

include { 'components/dpmlfc/config' };
"/software/components/dpmlfc/dependencies/pre" = push("accounts","mysql");
"/software/components/dpmlfc/options/lfc/user" = LFC_USER;
"/software/components/dpmlfc/options/lfc/group" = LFC_GROUP;
# Ideally installDir should use GLITE_LOCATION for during migration to
# EMI GLITE_LOCATION was set to /usr which is not appropriate.
# TO BE FIXED whend GLITE_LOCATION is really the root of all directory used.
"/software/components/dpmlfc/options/lfc/installDir" = {
  if ( INSTALL_ROOT == "" ) {
    install_dir = '/';
  } else {
    install_dir = INSTALL_ROOT;
  };
  install_dir;
};
"/software/components/dpmlfc/options/lfc/gridmapfile" ?= SITE_DEF_GRIDMAP;
"/software/components/dpmlfc/options/lfc/gridmapdir" ?= SITE_DEF_GRIDMAPDIR;


# Define some default values for DB related properties

variable LFC_DB_PARAMS = {
  if ( !is_defined(SELF['configfile']) ) {
    SELF['configfile'] = LFC_DB_CONFIG_FILE_DEFAULT;
  };
  if ( !is_defined(SELF['password']) ) {
    debug("LFC_DB_PARAMS['password'] undefined (DB connection password)");
  };
  if ( !is_defined(SELF['user']) ) {
    # LFC_DB_USER is the legacy variable
    if ( is_defined(LFC_DB_USER) ) {
      SELF['user'] = LFC_DB_USER;
    } else {
      SELF['user'] = LFC_USER;
    };
  };
  if ( !is_defined(SELF['adminuser']) ) {
    # LFC_MYSQL_ADMINUSER is the legacy variable
    if ( is_defined(LFC_MYSQL_ADMINUSER) ) {
      SELF['adminuser'] = LFC_MYSQL_ADMINUSER;
    } else {
      SELF['adminuser'] = LFC_MYSQL_ADMINUSER_DEFAULT;
    };
  };
  if ( !is_defined(SELF['adminpwd']) ) {
    # LFC_MYSQL_ADMINPWD is the legacy variable
    if ( is_defined(LFC_MYSQL_ADMINPWD) ) {
      SELF['adminpwd'] = LFC_MYSQL_ADMINPWD;
    } else {
      debug("LFC_DB_PARAMS['adminpwd'] undefined (DB '+LFC_DB_PARAMS['adminuser']+' password)");
    };
  };
  SELF;
};
"/software/components/dpmlfc/options/lfc/db/configfile" ?= LFC_DB_PARAMS['configfile']; 
"/software/components/dpmlfc/options/lfc/db/user" ?= LFC_DB_PARAMS['user']; 
"/software/components/dpmlfc/options/lfc/db/password" ?= LFC_DB_PARAMS['password']; 
"/software/components/dpmlfc/options/lfc/db/server" ?= if ( is_defined(LFC_DB_PARAMS['server']) ) {
                                                         LFC_DB_PARAMS['server']; 
                                                       } else {
                                                         null; 
                                                       }; 


# Configure LFC services

variable LFC_ENABLED_SERVICES ?= list('lfc','lfc-dli');
"/software/components/dpmlfc/" = {
  foreach (i;service;LFC_ENABLED_SERVICES) {
    if ( is_defined(LFC_SERVICE_PARAMS[service]) ) {
      host_params = LFC_SERVICE_PARAMS[service];
    } else {
      host_params = nlist();
    };
    SELF[service] = nlist(FULL_HOSTNAME, host_params);
  };
  SELF;
};


# ----------------------------------------------------------------------------
# DB Configuration
# ----------------------------------------------------------------------------
include { 'components/mysql/config' };

# configure MySQL databases for LFC SE
'/software/components/mysql/servers/' = {
  SELF[LFC_MYSQL_SERVER]['adminuser'] = LFC_DB_PARAMS['adminuser'];
  SELF[LFC_MYSQL_SERVER]['adminpwd'] = LFC_DB_PARAMS['adminpwd'];
  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[LFC_DB_NAME]['server'] = LFC_MYSQL_SERVER;
  SELF[LFC_DB_NAME]['createDb'] = false;
  SELF[LFC_DB_NAME]['initScript']['file'] = LFC_DB_INIT_SCRIPT;
  SELF[LFC_DB_NAME]['initOnce'] = true;
  SELF[LFC_DB_NAME]['users'][LFC_DB_PARAMS['user']] = nlist('password', LFC_DB_PARAMS['password'],
                                                           'rights', list('ALL PRIVILEGES'),
                                                          );

  SELF;
};

	
# Define service port numbers to match site parameters if not explicitly defined
"/software/components/dpmlfc" = {
  # Each service is described as a list of nlist. Port option is in the nlist.
  # Entries in LFC config that are not related to service definition will be ignored
  # (no matching entry in LFC_PORTS).
  foreach (service;service_params;SELF) {
    if ( is_defined(LFC_PORTS[service]) ) {
      # Need to iterate over all defined nodes for the service as there is no break statement.
      # This should not have side effect as there should be only one entry per node.
      foreach (node;node_params;service_params) {
        debug('LFC host '+to_string(node)+': defining port to '+to_string(LFC_PORTS[service])+' for service '+to_string(service));
        # Unconditionnaly define service port to match global variable
        SELF[service][node]['port'] = LFC_PORTS[service];
      };
    };
  };

  SELF;
};

# ---------------------------------------------------------------------------- 
# Define VO to configure in LFC namespace
# ---------------------------------------------------------------------------- 
"/software/components/dpmlfc/vos" = {
  foreach (i;vo;VOS) {
    if ( is_defined(VO_INFO[vo]['name']) ) {
      vo_name = VO_INFO[vo]['name'];
    } else {
      error('VO '+vo+' real name not defined');
    };
    SELF[vo_name] = nlist();
  };

  if ( length(SELF) == 0 ) {
    null;
  } else {
    SELF;
  };
};

# ---------------------------------------------------------------------------- 
# iptables
# ---------------------------------------------------------------------------- 

variable LFC_IPTABLES_RULES ?= {
  if ( !is_null(SELF) ) {
    lfc_config = value('/software/components/dpmlfc');
    # Use an nlist to handle duplicates in case of any (should not)
    port_list = nlist();
    
    # For each element in dpmlfc configuration, check if it is a service (if an
    # entry exists in LFC_PORTS) and, if yes, get the corresponding ports from
    # LFC_PORTS (ports in dpmlfc configuration are set to LFC_PORTS contents) if
    # the service runs on current node.
    foreach (service;port;LFC_PORTS) {
      if ( is_defined(lfc_config[service]) ) {
        foreach (node;params;lfc_config[service]) {
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

variable LFC_IPTABLES_INCLUDE = if ( is_defined(LFC_IPTABLES_RULES) && (length(LFC_IPTABLES_RULES) > 0) ) {
                                  'components/iptables/config';
                                } else {
                                  null;
                                };
include { LFC_IPTABLES_INCLUDE };
"/software/components/iptables/filter/rules" = {
  rules = list();
  if ( !is_null(LFC_IPTABLES_INCLUDE) ) {
    rules = merge(rules,LFC_IPTABLES_RULES);
  };
  if ( length(rules) > 0 ) {
    rules;
  } else {
    null;
  };
};


