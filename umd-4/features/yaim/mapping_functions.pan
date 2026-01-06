declaration template features/yaim/mapping_functions;

include 'features/yaim/functions';

#
# yaim_mapping:     Map a predefined set of variables to Yaim's config
# parameters:       nodetypelist - list of strings
# return:           contents for /software/components/yaim
#
function yaim_mapping = {
    x = SELF;
    if ( ARGC != 1 ) {
        error("Missing argument nodetypes in function yaim_mapping");
    };
    if ( ! is_list(ARGV[0]) ) {
        error("Argument nodetypes has to be of type list");
    };

    # set node type
    x['nodetype'] = ARGV[0];
    nodetypes = dict();
    foreach (i; nt; ARGV[0]) {
        nodetypes[nt] = true;
    };

    #
    # generic part
    #

    x['SITE_INFO_DEF_FILE'] = YAIM_SITE_INFO_DEF_FILE;
    x['USE_VO_D'] = YAIM_USE_VO_D;

    x['conf']['INSTALL_ROOT'] = INSTALL_ROOT;
    x['conf']['YAIM_HOME'] = YAIM_HOME;
    x['conf']['WN_LIST'] = YAIM_WNLIST_CFGFILE;
    x['conf']['USERS_CONF'] = YAIM_USERSCONF_CFGFILE;
    x['conf']['GROUPS_CONF'] = YAIM_GROUPSCONF_CFGFILE;
    x['conf']['FUNCTIONS_DIR'] = YAIM_FUNCTIONS_DIR;
    x['conf']['YAIM_VERSION'] = YAIM_VERSION;

    x['conf']['BATCH_SERVER'] = '';

    x['conf']['CE_HOST'] = CE_HOST;
    x['conf']['CLASSIC_HOST'] = CLASSIC_HOST;
    x['conf']['DPM_HOST'] = DPM_HOST;
    x['conf']['LFC_HOST'] = LFC_HOST;
    x['conf']['RB_HOST'] = RB_HOST;
    x['conf']['PX_HOST'] = PX_HOST;
    x['conf']['BDII_HOST'] = BDII_HOST;
    x['conf']['MON_HOST'] = MON_HOST;
    x['conf']['WMS_HOST'] = WMS_HOST;
    x['conf']['LB_HOST'] = LB_HOST;
    x['conf']['REG_HOST'] = REG_HOST;

    x['conf']['BDII_LIST'] = BDII_LIST;

    x['conf']['SITE_BDII_HOST'] = SITE_BDII_HOST;

    x['conf']['JAVA_LOCATION'] = JAVA_LOCATION;

    x['conf']['CRON_DIR'] = CRON_DIR;

    x['conf']['MY_DOMAIN'] = MY_DOMAIN;

    x['conf']['GLOBUS_TCP_PORT_RANGE'] = GLOBUS_TCP_PORT_RANGE;

    x['conf']['SITE_EMAIL'] = SITE_EMAIL;
    x['conf']['SITE_NAME'] = SITE_NAME;
    x['conf']['SITE_VERSION'] = SITE_VERSION;

    x['conf']['SITE_LAT'] = SITE_LAT;
    x['conf']['SITE_LONG'] = SITE_LONG;
    x['conf']['SITE_LOC'] = SITE_LOC;
    x['conf']['SITE_WEB'] = SITE_WEB;

    x['conf']['SITE_SUPPORT_EMAIL'] = SITE_SUPPORT_EMAIL;

    x['conf']['GLITE_HOME_DIR'] = GLITE_HOME_DIR;
    x['conf']['GLITE_USER_HOME'] = GLITE_HOME_DIR;      # workaround for GGUS #47552

    x['extra']['SITE_DESC'] = SITE_DESC;
    x['extra']['SITE_SECURITY_EMAIL'] = SITE_SECURITY_EMAIL;

    x['extra']['SITE_OTHER_EGEE_ROC'] = SITE_OTHER_EGEE_ROC;
    x['extra']['SITE_OTHER_GRID'] = SITE_OTHER_GRID;
    x['extra']['SITE_OTHER_WLCG_TIER'] = SITE_OTHER_WLCG_TIER;
    x['extra']['SITE_OTHER_WLCG_NAME'] = SITE_OTHER_WLCG_NAME;
    x['extra']['SITE_OTHER_WLCG_PARENT'] = SITE_OTHER_WLCG_PARENT;
    x['extra']['SITE_OTHER_EGEE_SERVICE'] = SITE_OTHER_EGEE_SERVICE;

    x['extra']['GRIDMAPDIR'] = GRIDMAPDIR;
    x['extra']['CONFIG_USERS'] = CONFIG_USERS;

    x['extra']['SE_LIST'] = SE_LIST;

    x['extra']['SPECIAL_POOL_ACCOUNTS'] = SPECIAL_POOL_ACCOUNTS;

    x['extra']['GRIDFTP_CONNECTIONS_MAX'] = GRIDFTP_CONNECTIONS_MAX;
    x['extra']['UNPRIVILEGED_MKGRIDMAP'] = UNPRIVILEGED_MKGRIDMAP;

    x['extra']['GLITE_USER'] = GLITE_USER;

    # CE info
    if ( exists(nodetypes['lcg-CE']) ) {
        x['conf']['SE_TYPE'] = SE_TYPE;
        x['conf']['JOB_MANAGER'] = JOB_MANAGER;

        x['CE']['BATCH_SYS'] = CE_BATCH_SYS;
        x['CE']['CPU_MODEL'] = CE_CPU_MODEL;
        x['CE']['CPU_VENDOR'] = CE_CPU_VENDOR;
        x['CE']['CPU_SPEED'] = CE_CPU_SPEED;
        x['CE']['OS'] = CE_OS;
        x['CE']['OS_RELEASE'] = CE_OS_RELEASE;
        x['CE']['OS_VERSION'] = CE_OS_VERSION;
        x['CE']['MINPHYSMEM'] = CE_MINPHYSMEM;
        x['CE']['MINVIRTMEM'] = CE_MINVIRTMEM;
        x['CE']['SMPSIZE'] = CE_SMPSIZE;
        x['CE']['SI00'] = CE_SI00;
        x['CE']['SF00'] = CE_SF00;
        x['CE']['OUTBOUNDIP'] = CE_OUTBOUNDIP;
        x['CE']['INBOUNDIP'] = CE_INBOUNDIP;
        x['CE']['RUNTIMEENV'] = CE_RUNTIMEENV;

        x['CE']['OS_ARCH'] = CE_OS_ARCH;
        x['CE']['PHYSCPU'] = CE_PHYSCPU;
        x['CE']['LOGCPU'] = CE_LOGCPU;

        x['conf']['CE_OTHERDESCR'] = CE_OTHERDESCR;
        x['conf']['CE_CAPABILITY'] = CE_CAPABILITY;

        # SEs
        x['conf']['CLASSIC_STORAGE_DIR'] = CLASSIC_STORAGE_DIR;
        x['conf']['SE_MOUNT_INFO_LIST'] = SE_MOUNT_INFO_LIST;

        # Base dir for VO software installation
        x['conf']['VO_SW_DIR'] = VO_SW_DIR;

        x['extra']['MAUI_KEYFILE'] = '';
        x['extra']['CONFIG_MAUI'] = "no";
    };

    # CE info
    if ( exists(nodetypes['creamCE']) ) {
        x['conf']['MYSQL_PASSWORD'] = MYSQL_PASSWORD;
        x['conf']['CREAM_DB_USER'] = CREAM_DB_USER;
        x['conf']['CREAM_CE_STATE'] = CREAM_CE_STATE;
        x['conf']['CREAM_DB_PASSWORD'] = CREAM_DB_PASSWORD;
        x['conf']['BLPARSER_WITH_UPDATER_NOTIFIER'] = BLPARSER_WITH_UPDATER_NOTIFIER;
        x['conf']['BLPARSER_HOST'] = BLPARSER_HOST;
        x['conf']['BATCH_LOG_DIR'] = BATCH_LOG_DIR;
        x['conf']['CEMON_HOST'] = CEMON_HOST;

        x['conf']['SE_TYPE'] = SE_TYPE;
        x['conf']['JOB_MANAGER'] = JOB_MANAGER;

        x['CE']['BATCH_SYS'] = CE_BATCH_SYS;
        x['CE']['CPU_MODEL'] = CE_CPU_MODEL;
        x['CE']['CPU_VENDOR'] = CE_CPU_VENDOR;
        x['CE']['CPU_SPEED'] = CE_CPU_SPEED;
        x['CE']['OS'] = CE_OS;
        x['CE']['OS_RELEASE'] = CE_OS_RELEASE;
        x['CE']['OS_VERSION'] = CE_OS_VERSION;
        x['CE']['MINPHYSMEM'] = CE_MINPHYSMEM;
        x['CE']['MINVIRTMEM'] = CE_MINVIRTMEM;
        x['CE']['SMPSIZE'] = CE_SMPSIZE;
        x['CE']['SI00'] = CE_SI00;
        x['CE']['SF00'] = CE_SF00;
        x['CE']['OUTBOUNDIP'] = CE_OUTBOUNDIP;
        x['CE']['INBOUNDIP'] = CE_INBOUNDIP;
        x['CE']['RUNTIMEENV'] = CE_RUNTIMEENV;

        x['CE']['OS_ARCH'] = CE_OS_ARCH;
        x['CE']['PHYSCPU'] = CE_PHYSCPU;
        x['CE']['LOGCPU'] = CE_LOGCPU;

        x['conf']['CE_OTHERDESCR'] = CE_OTHERDESCR;
        x['conf']['CE_CAPABILITY'] = CE_CAPABILITY;

        # SEs
        x['conf']['CLASSIC_STORAGE_DIR'] = CLASSIC_STORAGE_DIR;
        x['conf']['SE_MOUNT_INFO_LIST'] = SE_MOUNT_INFO_LIST;

        # Base dir for VO software installation
        x['conf']['VO_SW_DIR'] = VO_SW_DIR;
    };


    # BDII site
    if ( exists(nodetypes['BDII_site']) ) {
        x['conf']['BDII_REGIONS'] = "";
        ul = BDII_URLS;
        ok = first(ul, k, v);
        while ( ok ) {
            if (length(x['conf']['BDII_REGIONS']) > 0) {
                x['conf']['BDII_REGIONS'] = x['conf']['BDII_REGIONS'] + " " + k;
            }
            else {
                x['conf']['BDII_REGIONS'] = k;
            };
            x['conf']['BDII_' + k + '_URL'] = v;
            ok = next(ul, k, v);
        };
    };

    # BDII top
    if ( exists(nodetypes['BDII_top']) ) {
        x['conf']['BDII_HTTP_URL'] = BDII_HTTP_URL;
        x['extra']['BDII_BREATHE_TIME'] = BDII_BREATHE_TIME;
        x['extra']['GIP_RESPONSE'] = GIP_RESPONSE;
    };


    # DPM
    if ( exists(nodetypes['SE_dpm_mysql']) ||
        exists(nodetypes['SE_dpm_disk']) ) {
        x['conf']['DPMPOOL'] = DPMPOOL;
        x['conf']['DPMFSIZE'] = DPMFSIZE;
        x['conf']['DPM_FILESYSTEMS'] = DPM_FILESYSTEMS;
        x['extra']['SE_GRIDFTP_LOGFILE'] = SE_GRIDFTP_LOGFILE;
    };
    if ( exists(nodetypes['SE_dpm_mysql']) ) {
        x['conf']['MYSQL_PASSWORD'] = MYSQL_PASSWORD;
        x['conf']['DPM_DB_HOST'] = DPM_DB_HOST;
        x['conf']['DPNS_DB'] = DPNS_DB;
        x['conf']['DPM_DB'] = DPM_DB;
        x['conf']['DPM_DB_USER'] = DPM_DB_USER;
        x['conf']['DPM_DB_PASSWORD'] = DPM_DB_PASSWORD;
        x['conf']['DPM_INFO_USER'] = DPM_INFO_USER;
        x['conf']['DPM_INFO_PASS'] = DPM_INFO_PASS;
    };

    # LFC
    if ( exists(nodetypes['LFC_mysql']) ) {
        x['conf']['MYSQL_PASSWORD'] = MYSQL_PASSWORD;
        x['conf']['LFC_DB_PASSWORD'] = LFC_DB_PASSWORD;
        x['conf']['LFC_DB'] = LFC_DB;
        x['conf']['LFC_DB_HOST'] = LFC_DB_HOST;
        x['extra']['LFCMGR'] = LFCMGR;
    };


    # VOBOX
    if ( exists(nodetypes['VOBOX']) ) {
        x['conf']['VOBOX_HOST'] = VOBOX_HOST;
        x['conf']['VOBOX_PORT'] = VOBOX_PORT;

        # hack to ensure that there is only one SGM user
        x['extra']['VOBOX_SGM_USER'] = VOBOX_SGM_USER;
    };

    # MON
    if ( exists(nodetypes['MON']) ) {
        x['conf']['MYSQL_PASSWORD'] = MYSQL_PASSWORD;
        x['conf']['FTS_SERVER_URL'] = FTS_SERVER_URL;
    };
    if ( exists(nodetypes['MON']) ) {
        # APEL disabled
        x['conf']['APEL_DB_PASSWORD'] = APEL_DB_PASSWORD;
    };

    # LB
    if ( exists(nodetypes['glite-LB']) ) {
        x['conf']['MYSQL_PASSWORD'] = MYSQL_PASSWORD;
    };

    # WMS
    if ( exists(nodetypes['glite-WMS']) ) {
        x['conf']['MYSQL_PASSWORD'] = MYSQL_PASSWORD;
    };

    # GLEXEC at WN
    if ( exists(nodetypes['GLEXEC_wn']) ) {
        x['GLEXEC']['GLEXEC_WN_SCAS_ENABLED'] = GLEXEC_WN_SCAS_ENABLED;
        x['GLEXEC']['GLEXEC_WN_OPMODE'] = GLEXEC_WN_OPMODE;
        x['GLEXEC']['GLEXEC_EXTRA_WHITELIST'] = GLEXEC_EXTRA_WHITELIST;
        x['GLEXEC']['SCAS_HOST'] = SCAS_HOST;
        x['GLEXEC']['SCAS_PORT'] = SCAS_PORT;
        x['GLEXEC']['SCAS_ENDPOINTS'] = SCAS_ENDPOINTS;
    };

    if ( exists(nodetypes['PX']) ) {
        x['conf']['GRID_TRUSTED_BROKERS'] =             GRID_TRUSTED_BROKERS;
        x['conf']['GRID_ACCEPTED_CREDENTIALS'] =        GRID_ACCEPTED_CREDENTIALS;
        x['conf']['GRID_AUTHORIZED_RENEWERS'] =         GRID_AUTHORIZED_RENEWERS;
        x['conf']['GRID_DEFAULT_RENEWERS'] =            GRID_DEFAULT_RENEWERS;
        x['conf']['GRID_AUTHORIZED_RETRIEVERS'] =       GRID_AUTHORIZED_RETRIEVERS;
        x['conf']['GRID_DEFAULT_RETRIEVERS'] =          GRID_DEFAULT_RETRIEVERS;
        x['conf']['GRID_AUTHORIZED_KEY_RETRIEVERS'] =   GRID_AUTHORIZED_KEY_RETRIEVERS;
        x['conf']['GRID_DEFAULT_KEY_RETRIEVERS'] =      GRID_DEFAULT_KEY_RETRIEVERS;
        x['conf']['GRID_TRUSTED_RETRIEVERS'] =          GRID_TRUSTED_RETRIEVERS;
        x['conf']["GRID_DEFAULT_TRUSTED_RETRIEVERS"] =  GRID_DEFAULT_TRUSTED_RETRIEVERS;
    };

    # NAGIOS
    if ( exists(nodetypes['NAGIOS']) ) {
        x['extra']['NCG_MAIN_DB_FILE'] =            NCG_MAIN_DB_FILE;
        x['extra']['NCG_MAIN_DB_DIR'] =             NCG_MAIN_DB_DIR;
        x['extra']['NCG_TEMPLATES_DIR'] =           NCG_TEMPLATES_DIR;
        x['extra']['NCG_OUTPUT_DIR'] =              NCG_OUTPUT_DIR;
        x['extra']['NCG_NRPE_OUTPUT_DIR'] =         NCG_NRPE_OUTPUT_DIR;
        x['extra']['NCG_VO'] =                      NCG_VO;
        x['extra']['NCG_NRPE_UI'] =                 NCG_NRPE_UI;
        x['extra']['NCG_PROBES_TYPE'] =             NCG_PROBES_TYPE;
        x['extra']['NAGIOS_HOST'] =                 NAGIOS_HOST;
        x['extra']['NAGIOS_HTPASSWD_FILE'] =        NAGIOS_HTPASSWD_FILE;
        x['extra']['NAGIOS_TIMEOUT'] =              NAGIOS_TIMEOUT;
        x['extra']['NAGIOS_ROLE'] =                 NAGIOS_ROLE;
        x['extra']['NAGIOS_MYPROXY_USER'] =         NAGIOS_MYPROXY_USER;
        x['extra']['NAGIOS_DB_HOST'] =              NAGIOS_DB_HOST;
        x['extra']['NAGIOS_DB_USER'] =              NAGIOS_DB_USER;
        x['extra']['NAGIOS_DB_PASS'] =              NAGIOS_DB_PASS;
        x['extra']['NAGIOS_HTTPD_ENABLE_CONFIG'] =  NAGIOS_HTTPD_ENABLE_CONFIG;
        x['extra']['NAGIOS_NCG_ENABLE_CONFIG'] =    NAGIOS_NCG_ENABLE_CONFIG;
        x['extra']['NAGIOS_NAGIOS_ENABLE_CONFIG'] = NAGIOS_NAGIOS_ENABLE_CONFIG;
        x['extra']['NAGIOS_CGI_ENABLE_CONFIG'] =    NAGIOS_CGI_ENABLE_CONFIG;
        x['extra']['NAGIOS_SUDO_ENABLE_CONFIG'] =   NAGIOS_SUDO_ENABLE_CONFIG;
        x['extra']['MSG_BROKER_CACHE_NETWORK'] =    MSG_BROKER_CACHE_NETWORK;
        x['extra']['MYSQL_ADMIN'] =                 MYSQL_ADMIN;
        x['extra']['NAGIOS_NSCA_PASS'] =            NSCA_PASSWORD;
    };

    # NRPE
    if ( exists(nodetypes['NRPE']) ) {
        x['extra']['NAGIOS_HOST'] =                 NAGIOS_HOST;
        x['extra']['NAGIOS_TIMEOUT'] =              NAGIOS_TIMEOUT;
        x['extra']['NAGIOS_NSCA_PASS'] =            NSCA_PASSWORD;
        x['extra']['NCG_NRPE_UI'] =                 NCG_NRPE_UI;
    };

    # Kerberos authentication
    x['conf']['GSSKLOG'] = GSSKLOG;


    # We require more ldap servers for VO authentication than just the one at CERN
    x['conf']['GRIDMAP_AUTH'] = GRIDMAP_AUTH;

    x['extra']['GLITE_USER_HOME'] = GLITE_USER_HOME;

    x['extra']['GLITE_LOCAL_CUSTOMISATION_DB'] = GLITE_LOCAL_CUSTOMISATION_DB;
    x['extra']['GLITE_SD_PLUGIN'] = GLITE_SD_PLUGIN;
    x['extra']['GLITE_SD_SERVICES'] = GLITE_SD_SERVICES;

    # MPI configuration

    if ( exists(nodetypes['MPI_CE'])  || exists(nodetypes['MPI_WN']) ) {
        x['MPI']['MPI_MPICH_ENABLE'] =        MPI_MPICH_ENABLE;
        x['MPI']['MPI_MPICH2_ENABLE'] =       MPI_MPICH2_ENABLE;
        x['MPI']['MPI_OPENMPI_ENABLE'] =      MPI_OPENMPI_ENABLE;
        x['MPI']['MPI_LAM_ENABLE'] =          MPI_LAM_ENABLE;
#        x['MPI']['MPI_MPICH_PATH'] =          MPI_MPICH_PATH;
#        x['MPI']['MPI_MPICH_VERSION'] =       MPI_MPICH_VERSION;
#        x['MPI']['MPI_MPICH2_PATH'] =         MPI_MPICH2_PATH;
#        x['MPI']['MPI_MPICH2_VERSION'] =      MPI_MPICH2_VERSION;
        x['MPI']['MPI_OPENMPI_PATH'] =        MPI_OPENMPI_PATH;
        x['MPI']['MPI_OPENMPI_VERSION'] =     MPI_OPENMPI_VERSION;
#        x['MPI']['MPI_LAM_VERSION'] =         MPI_LAM_VERSION;
#        x['MPI']['MPI_MPICH_MPIEXEC'] =       MPI_MPICH_MPIEXEC;
#        x['MPI']['MPI_MPICH2_MPIEXEC'] =      MPI_MPICH2_MPIEXEC;
        x['MPI']['MPI_OPENMPI_MPIEXEC'] =     MPI_OPENMPI_MPIEXEC;
        x['MPI']['MPI_SHARED_HOME'] =         MPI_SHARED_HOME;
        x['MPI']['MPI_SSH_HOST_BASED_AUTH'] = MPI_SSH_HOST_BASED_AUTH;
    };




    return(x);
};
