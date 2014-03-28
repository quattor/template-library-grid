# This template must called after glite/se_dpm/config as it depends on many
# variables defined in it.

unique template personality/se_dpm/server/config;

variable DMLITE_ENABLED ?= false;
variable GIP_SCRIPT_DPM_DYNAMIC_CONFIG ?= null;
variable SEDPM_DB_TYPE = 'mysql';

# Hostname of the machine hosting the DPM DB
variable DPM_MYSQL_SERVER ?= FULL_HOSTNAME;

# DB user name and passwor
variable DPM_MYSQL_ADMINUSER_DEFAULT = 'root';

variable DPM_DB_USER ?= DPM_USER;
variable DPM_DB_NAME ?= 'dpm_db';
variable DPM_DB_INIT_SCRIPT ?= '/usr/share/DPM/create_dpm_tables_mysql.sql';

variable DPNS_DB_NAME ?= 'cns_db';
variable DPNS_DB_INIT_SCRIPT ?= '/usr/share/DPM/create_dpns_tables_mysql.sql';

variable DPM_DB_CONFIG_FILE_DEFAULT ?= '/etc/DPMCONFIG';


# ncm-mysql must be executed first
include { 'components/dpmlfc/config' };
'/software/components/dpmlfc/dependencies/pre' = push('mysql');

# Define some default values for DB related properties
variable DPM_DB_PARAMS = {
  if ( !is_defined(SELF['configfile']) ) {
    SELF['configfile'] = DPM_DB_CONFIG_FILE_DEFAULT;
  };
  if ( !is_defined(SELF['password']) ) {
    debug("DPM_DB_PARAMS['password'] undefined (DB connection password)");
  };
  if ( !is_defined(SELF['user']) ) {
    # DPM_DB_USER is the legacy variable
    if ( is_defined(DPM_DB_USER) ) {
      SELF['user'] = DPM_DB_USER;
    } else {
      SELF['user'] = DPM_USER;
    };
  };
  if ( !is_defined(SELF['adminuser']) ) {
    # DPM_MYSQL_ADMINUSER is the legacy variable
    if ( is_defined(DPM_MYSQL_ADMINUSER) ) {
      SELF['adminuser'] = DPM_MYSQL_ADMINUSER;
    } else {
      SELF['adminuser'] = DPM_MYSQL_ADMINUSER_DEFAULT;
    };
  };
  if ( !is_defined(SELF['adminpwd']) ) {
    # DPM_MYSQL_ADMINPWD is the legacy variable
    if ( is_defined(DPM_MYSQL_ADMINPWD) ) {
      SELF['adminpwd'] = DPM_MYSQL_ADMINPWD;
    } else {
      debug("DPM_DB_PARAMS['adminpwd'] undefined (DB '+DPM_DB_PARAMS['adminuser']+' password)");
    };
  };
  SELF;
};
"/software/components/dpmlfc/options/dpm/db/configfile" ?= DPM_DB_PARAMS['configfile']; 
"/software/components/dpmlfc/options/dpm/db/user" ?= DPM_DB_PARAMS['user']; 
"/software/components/dpmlfc/options/dpm/db/password" ?= DPM_DB_PARAMS['password']; 
"/software/components/dpmlfc/options/dpm/db/server" ?= if ( is_defined(DPM_DB_PARAMS['server']) ) {
                                                         DPM_DB_PARAMS['server']; 
                                                       } else {
                                                         null; 
                                                       }; 
"/software/components/dpmlfc/options/dpm/db/infoUser" ?= if ( is_defined(DPM_DB_PARAMS['infoUser']) ) {
                                                         DPM_DB_PARAMS['infoUser']; 
                                                       } else {
                                                         null; 
                                                       }; 
"/software/components/dpmlfc/options/dpm/db/infoPwd" ?= if ( is_defined(DPM_DB_PARAMS['infoPwd']) ) {
                                                         DPM_DB_PARAMS['infoPwd']; 
                                                       } else {
                                                         null; 
                                                       }; 
"/software/components/dpmlfc/options/dpm/db/infoFile" ?= if ( is_defined(DPM_DB_PARAMS['infoFile']) ) {
                                                         DPM_DB_PARAMS['infoFile']; 
                                                       } else {
                                                         null; 
                                                       }; 


# ----------------------------------------------------------------------------
# DB Configuration
# ----------------------------------------------------------------------------
include { 'components/mysql/config' };

# configure MySQL databases for DPM SE
'/software/components/mysql/servers/' = {
  SELF[DPM_MYSQL_SERVER]['adminuser'] = DPM_DB_PARAMS['adminuser'];
  SELF[DPM_MYSQL_SERVER]['adminpwd'] = DPM_DB_PARAMS['adminpwd'];
  SELF;
};

'/software/components/mysql/databases/' = {
  SELF[DPM_DB_NAME]['server'] = DPM_MYSQL_SERVER;
  SELF[DPM_DB_NAME]['createDb'] = false;
  SELF[DPM_DB_NAME]['initScript']['file'] = DPM_DB_INIT_SCRIPT;
  SELF[DPM_DB_NAME]['initOnce'] = true;
  SELF[DPM_DB_NAME]['users'][DPM_DB_PARAMS['user']] = nlist('password', DPM_DB_PARAMS['password'],
                                                           'rights', list('ALL PRIVILEGES'),
                                                          );

  SELF[DPNS_DB_NAME]['server'] = DPM_MYSQL_SERVER;
  SELF[DPNS_DB_NAME]['createDb'] = false;
  SELF[DPNS_DB_NAME]['initScript']['file'] = DPNS_DB_INIT_SCRIPT;
  SELF[DPNS_DB_NAME]['initOnce'] = true;
  SELF[DPNS_DB_NAME]['users'][DPM_DB_PARAMS['user']] = nlist('password', DPM_DB_PARAMS['password'],
                                                            'rights', list('ALL PRIVILEGES'),
                                                           );

  SELF;
};


# Define DPM/DPNS host in login scripts to help using DPM commands
"/software/components/profile/env" = {
  SELF["DPM_HOST"] = FULL_HOSTNAME;
  SELF["DPNS_HOST"] = FULL_HOSTNAME;
  SELF;
};

# Define VO to configure in DPM namespace
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

# dmlite configuration specific to head node if needed
variable DEBUG = debug(OBJECT+': DMLITE_ENABLED='+to_string(DMLITE_ENABLED));
include { if ( DMLITE_ENABLED ) 'personality/se_dpm/server/config_dmlite' };


# Check if a site specific version of GIP DPM plugin is used and configure it if needed 

include { 'components/filecopy/config' };

include { GIP_SCRIPT_DPM_DYNAMIC_CONFIG };

'/software/components/filecopy/services' = {
  if ( is_defined(GIP_SCRIPT_DPM_DYNAMIC) ) {
    SELF[escape(GIP_SCRIPT_DPM_DYNAMIC_NAME)] = nlist('config', GIP_SCRIPT_DPM_DYNAMIC,
                                                      'owner', 'root:root',
                                                      'perms', '0755'
                                                      );
  };
  SELF;
};
    

