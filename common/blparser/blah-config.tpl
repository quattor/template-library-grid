# Template to configure the BLAH environment
# Used by blparser startup script and by CREAM submission

unique template common/blparser/blah-config;

# Should have been defined before, for example by service.tpl
variable BLPARSER_HOST ?= error('BLPARSER_HOST is not defined');

variable BLPARSER_PBS_SPOOLDIR ?= if ( is_defined(TORQUE_CONFIG_DIR) ) {
                                    TORQUE_CONFIG_DIR;
                                  } else {
                                    if ( BLPARSER_BATCH_SYS == 'pbs' ) {
                                      error('TORQUE_CONFIG_DIR must be defined to configure BLParser for Torque');
                                    } else {
                                      ''
                                    };
                                  };
variable LSF_BINPATH ?= '';
variable LSF_CONFPATH ?= '';

#Assuming that we are using Torque > = 2.5.7
variable BLAH_TORQUE_MULTIPLE_STAGING_DIRECTIVE_BUG = {
        if(TORQUE_VERSION == '2.5.7-7.el5'){
                return("yes");
        }else{
                return("no");
        };

};


# Include blparser parameters for the supported lrms
include { 'common/blparser/init' };


# blparser configuration file
include { 'components/filecopy/config' };
variable BLAH_CONF_FILE = GLITE_LOCATION_ETC + '/blah.config';
variable BLAH_CONF_CONTENTS = {
  contents = "# BLAH Configuration file\n";
  contents = contents + "supported_lrms=" + BLPARSER_BATCH_SYS +"\n";
  contents = contents + "blah_child_poll_timeout=" + to_string(BLAH_CHILD_POLL_TIMEOUT) + "\n";
  if (BLPARSER_BATCH_SYS == 'lsf') {
    contents = contents + '. ' + LSFPROFILE_DIR + '/profile.lsf' + "\n";
  };

    contents = contents + "# working on glexec -> sudo support\n";
    contents = contents + "blah_disable_proxy_user_copy=yes\n";
    contents = contents + "blah_id_mapping_command_sudo='/usr/bin/sudo -H'\n";
    contents = contents + "blah_set_default_workdir_to_home=yes\n";
    contents = contents + "blah_torque_multiple_staging_directive_bug="+BLAH_TORQUE_MULTIPLE_STAGING_DIRECTIVE_BUG+"\n";   

  contents = contents + "blah_disable_wn_proxy_renewal=yes\n";
  contents = contents + "BLAHPD_ACCOUNTING_INFO_LOG=" + BLAH_LOG_DIR + '/' + BLAH_LOG_FILE + "\n";
  contents = contents + BLPARSER_BATCH_SYS + "_binpath=/usr/bin\n";
  contents = contents + BLPARSER_BATCH_SYS + "_confpath=\n";
  contents = contents + BLPARSER_BATCH_SYS + "_spoolpath="+TORQUE_CONFIG_DIR+"\n";
  contents = contents + BLPARSER_BATCH_SYS + "_nochecksubmission=yes\n";
  contents = contents + BLPARSER_BATCH_SYS + "_nologaccess=\n";
  contents = contents + BLPARSER_BATCH_SYS + "_fallback=no\n";
  contents = contents + BLPARSER_BATCH_SYS + "_BLParser=yes\n";
  # Note that batch logs must be accessible on the CE when BLPARSER_WITH_UPDATER_NOTIFIER is true
  if ( BLPARSER_WITH_UPDATER_NOTIFIER ) {
    contents = contents + "job_registry="+GLITE_LOCATION_VAR+"/blah/user_blah_job_registry.bjr\n";

    contents = contents + "purge_interval="+to_string(BLAH_PURGE_INTERVAL)+"\n";
    contents = contents + "bupdater_path="+BLAH_UPDATER[BLPARSER_BATCH_SYS]+"\n";
    contents = contents + "bnotifier_path="+BLAH_NOTIFIER[BLPARSER_BATCH_SYS]+"\n";
    contents = contents + "bupdater_pidfile="+GLITE_LOCATION_VAR+'/blah_bupdater.pid'+"\n";
    contents = contents + "bnotifier_pidfile="+GLITE_LOCATION_VAR+'/blah_bnotifier.pid'+"\n";
    contents = contents + "bupdater_debug_level="+to_string(BLAH_UPDATER_DEBUG_LEVEL)+"\n";
    contents = contents + "bupdater_debug_logfile="+GLITE_LOCATION_LOG+'/'+BLAH_UPDATER_DEBUG_FILE+"\n";
    contents = contents + "bnotifier_debug_level="+to_string(BLAH_NOTIFIER_DEBUG_LEVEL)+"\n";
    contents = contents + "bnotifier_debug_logfile="+GLITE_LOCATION_LOG+'/'+BLAH_NOTIFIER_DEBUG_FILE+"\n";
    contents = contents + "blah_children_restart_interval=0";
  } else {
    contents = contents + BLPARSER_BATCH_SYS + "_BLPserver=" + BLPARSER_HOST + "\n";
    contents = contents + BLPARSER_BATCH_SYS + "_BLPport=" + to_string(BLPARSER_LRMS_PARAMS[BLPARSER_BATCH_SYS]['port']) + "\n";
    contents = contents + BLPARSER_BATCH_SYS + "_num_BLParser=\n";
    contents = contents + BLPARSER_BATCH_SYS + "_BLPserver1=\n";
    contents = contents + BLPARSER_BATCH_SYS + "_BLPport1=\n";
    contents = contents + BLPARSER_BATCH_SYS + "_BLPserver2=\n";
    contents = contents + BLPARSER_BATCH_SYS + "_BLPport2=\n";
  };

  contents;
};

# The BLParser service is running only on BLPARSER_HOST (LRMS server), not on CEs that are not LRMS server
variable BLAH_CONFIG_FILE_RESTART = if ( FULL_HOSTNAME == BLPARSER_HOST ) {
                                      "/sbin/service glite-ce-blah-parser restart";
                                    } else {
                                      null;
                                    };
"/software/components/filecopy/services" =
  npush(escape(BLAH_CONF_FILE),
        nlist("config",BLAH_CONF_CONTENTS,
              "owner","root",
              "perms","0644",
              "restart", BLAH_CONFIG_FILE_RESTART,
        )
  );

include { 'components/profile/config' };
'/software/components/profile' = component_profile_add_env(GLITE_GRID_ENV_PROFILE, nlist('BLAH_CONFIG_LOCATION',BLAH_CONF_FILE));


#------------------------------------------------------------------------------
# Configure logrotate for the BLAH client file (used by accounting)
#------------------------------------------------------------------------------
include { 'components/altlogrotate/config' };
"/software/components/altlogrotate/entries" = {
  SELF[BLAH_LOG_FILE] = nlist("pattern", BLAH_LOG_DIR+'/'+BLAH_LOG_FILE,
                              "compress", true,
                              "missingok", true,
                              "frequency", "weekly",
                              "create", true,
                              "ifempty", true,
                              "copytruncate", true,
                              "rotate", 10);
  SELF;
};


