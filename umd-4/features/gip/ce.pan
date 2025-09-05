unique template features/gip/ce;

include 'components/gip2/config';

variable GIP_CE_GLUE2_CONFIG_FILE ?= 'glite-ce-glue2.conf';

variable GIP_CE_GLUE2_LDIF_PROCESSOR_DIR ?= '/usr/libexec';

variable GIP_CE_GLUE2_LDIF_PROCESSORS = dict(
    'benchmark', 'glite-ce-glue2-benchmark-static',
    'endpoint', 'glite-ce-glue2-endpoint-static',
    'environment', 'glite-ce-glue2-executionenvironment-static',
    'manager', 'glite-ce-glue2-manager-static',
    'service', 'glite-ce-glue2-computingservice-static',
    'shares', 'glite-ce-glue2-share-static',
    'storage', 'glite-ce-glue2-tostorageservice-static',
);

variable GIP_CE_GLUE2_LDIF_FILES = dict(
    'benchmark', 'Benchmark.ldif',
    'endpoint', 'ComputingEndpoint.ldif',
    'environment', 'ExecutionEnvironment.ldif',
    'manager', 'ComputingManager.ldif',
    'service', 'ComputingService.ldif',
    'shares', 'ComputingShare.ldif',
    'storage', 'ToStorageService.ldif',
);

# Must be lower case according to EGI profile
variable CE_OS_FAMILY ?= 'linux';

@{
desc = define VO shares to be applied to each CE
values = percentage
default = none
required = no
}
variable CE_VO_SHARES ?= undef;

@{
desc = define default value for job maximum physical memory if not defined at the queue level
values = MB
default = 2000
required = no
}
variable CE_DEFAULT_MAX_PHYS_MEM ?= 2000 * MB;

@{
desc = define default value for job maximum virtual memory if not defined at the queue level
values = MB
default = 20000
required = no
}
variable CE_DEFAULT_MAX_VIRT_MEM ?= 20000 * MB;

@{
desc = define default value for maximum number of processors per job if not defined at the queue level
values = integer
default = 1
required = no
}
variable CE_DEFAULT_JOB_MAX_PROCS ?= 1;

variable CREAM_CE_VERSION ?= '1.14.0';


variable CE_HOSTS_CREAM ?= list();
variable CE_HOSTS_LCG ?= list();

variable CE_FLAVOR ?= if ( is_defined(CE_HOSTS_CREAM) && (index(FULL_HOSTNAME, CE_HOSTS_CREAM) >= 0) ) {
    'cream';
} else {
    undef;
};

variable CE_FLAVOR = {
    if ( is_defined(CE_FLAVOR) && !match(CE_FLAVOR, 'cream') ) {
        error("Invalid value for CE_FLAVOR (" + CE_FLAVOR + "). Must be 'cream'.");
    };
    SELF;
};

# Default static value for several job-related attributes (updated by dynamic info providers)
variable GLUE_FAKE_JOB_VALUE ?= 444444;

# Host publishing GlueCluster and GlueSubCluster information.
# This is important to ensure this is published once even though
# several CEs share the same cluster/WNs.
# Default: LRMS master node.
variable GIP_CLUSTER_PUBLISHER_HOST ?= LRMS_SERVER_HOST;
variable LRMS_PRIMARY_SERVER_HOST ?= LRMS_SERVER_HOST;

# CE close SE list
variable CE_CLOSE_SE_LIST ?= undef;

# CE port for each CE flavor
variable CE_PORT = dict(
    'cream', 8443,
);

# For GlueHostArchitecturePlatformType, assume the same type as CE until we support several subclusters
# per cluster.
variable CE_WN_ARCH ?= PKG_ARCH_DEFAULT;

# CE implementation for each flavor
variable GLUE_CE_IMPLEMENTATION = dict(
    'cream', 'CREAM',
);

# Which version of tomcat
variable TOMCAT_SERVICE ?= 'tomcat6';

# GIP service provider configuration.
# The value of GIP_PROVIDER_SERVICE_CONF_BASE is used as the base file name for the config file.
# GIP_CE_SERVICES defines the list of GlueService to publish for each CE flavor: there must be one matching
# entry for each value in GIP_CE_SERVICE_PARAMS.
variable GIP_PROVIDER_SERVICE_CONF_BASE ?= GIP_SCRIPTS_CONF_DIR + '/glite-info-service';
variable GIP_CE_SERVICES = dict(
    'cream', list('creamce', 'cemon'),
);
variable GIP_PROVIDER_SUBSERVICE ?= dict(
    'creamce', GIP_SCRIPTS_DIR + '/glite-info-service-cream',
    'cemon', GIP_SCRIPTS_DIR + '/glite-info-service-cream',
    'gatekeeper', GIP_SCRIPTS_DIR + '/glite-info-service-gatekeeper',
    'rtepublisher', GIP_SCRIPTS_DIR + '/glite-info-service-rtepublisher',
    'test', GIP_SCRIPTS_DIR + '/glite-info-service-test',
);
variable GIP_CE_SERVICE_PARAMS = dict(
    'creamce', dict(
        'type', 'org.glite.ce.CREAM',
        'endpoint', 'https://${CREAM_HOST}:${CREAM_PORT}/ce-cream/services',
        'service', TOMCAT_SERVICE,
        'service_status_name', 'CREAM',
        'version_rpm', 'glite-ce-cream',
        'pid_file', '$ENV{CREAM_PID_FILE}',
        'wsdl', 'http://grid.pd.infn.it/cream/wsdl/org.glite.ce-cream_service.wsdl',
        'semantics', 'https://edms.cern.ch/document/595770',
        'service_data', '',
        'implementationname', 'CREAM',
    ),
    'cemon', dict(
        'type', 'org.glite.ce.Monitor',
        'endpoint', 'https://${CREAM_HOST}:${CREAM_PORT}/ce-monitor/services/CEMonitor',
        'service', TOMCAT_SERVICE,
        'service_status_name', 'CEMON',
        'version_rpm', 'glite-ce-monitor',
        'pid_file', '$ENV{CREAM_PID_FILE}',
        'wsdl', 'http://grid.pd.infn.it/cemon/wsdl/org.glite.ce-mon_service.wsdl',
        'semantics', 'https://edms.cern.ch/document/585040',
        'service_data', '',
        'implementationname', 'CEmon',
    ),
    'gatekeeper', dict(
        'type', 'org.edg.gatekeeper',
        'endpoint', 'gram://$GATEKEEPER_HOST:$GATEKEEPER_PORT/',
        'service', 'globus-gatekeeper',
        'service_status_name', 'GATEKEEPER',
        'version', '2.0.0',
        'pid_file', '$ENV{GATEKEEPER_PROCDIR}',
        'wsdl', 'nohttp://not.a.web.service/',
        'semantics', 'http://www.globus.org/toolkit/docs/2.4/gram/',
        'service_data', '"Services=$GATEKEEPER_SERVICES\nDN=" && ' +
            'grid-cert-info -file /etc/grid-security/hostcert.pem -subject',
        'implementationname', 'GateKeeper',
    ),
    'rtepublisher', dict(
        'type', 'org.glite.RTEPublisher',
        'endpoint', 'gsiftp://$RTEPUBLISHER_HOST:$RTEPUBLISHER_PORT' + VO_SW_TAGS_DIR,
        'service', 'globus-gridftp',
        'service_status_name', 'RTEPUBLISHER',
        'version', 'echo 1.0.0',
        'pid_file', '$ENV{GRIDFTP_PROC_FILE}',
        'wsdl', 'nohttp://not.a.web.service/',
        'semantics', ' http://grid-deployment.web.cern.ch/grid-deployment/eis/docs/ExpSwInstall/sw-install.html',
        'service_data', GIP_CLUSTER_PUBLISHER_HOST,
        'implementationname', 'ApplicationPublisher',
    ),
);



# ----------------------------------------------------------------------------
# Add RPMs that are required by GIP on CE to update dynamic information
# ----------------------------------------------------------------------------
'/software/packages' = {
    pkg_repl('glite-ce-cream-utils');
    pkg_repl('glite-info-provider-service');
    if(CE_BATCH_SYS == 'condor'){ pkg_repl('dynsched-generic'); };
    SELF;
};


# ----------------------------------------------------------------------------
# HTCondor: add required scripts not part of official RPMs
# ----------------------------------------------------------------------------

# Necessary only the GIP_CLUSTER_PUBLISHER_HOST (generally LRMS_SERVER_HOST)
include  if( (CE_BATCH_SYS == 'condor') && (FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST) )
    'features/gip/ce-condor-plugins';


# ----------------------------------------------------------------------------
# Compute several variables summarizing the configuration
# ----------------------------------------------------------------------------

variable CE_DATADIR ?= 'unset';

#Build  GlueCECapability entry to publish
variable CE_CAPABILITIES = {
    SELF[length(SELF)] = 'CPUScalingReferenceSI00=' + to_string(CE_SI00);
    if ( is_defined(CE_VO_SHARES) ) {
        foreach (i; v; CE_VO_SHARES) {
            SELF[length(SELF)] = 'Share=' + i + ":" + to_string(v);
        };
    };
    SELF;
};


variable CE_STATE_STATUS = if ( exists(CE_STATUS) && is_defined(CE_STATUS) ) {
    CE_STATUS;
} else {
    'Production';
};

# Default queue configuration if not explicitly defined before.
# This will create one queue per VO with the queue name equal
# to the VO name and an empty 'attlist' for each queue.
# The format is a dict made of 2 dicts : 'vos' lists for each queue
# the VO with an access to it and 'attlist' lists for each queue the
# specific queue attributes.
variable CE_QUEUES ?= {
    queues = dict();
    queues['vos'] = dict();
    queues['attlist'] = dict();

    foreach (k; v; VOS) {
        queues['vos'][v] = list(v);
    };
    queues;
};

# List of batch system configured.
# In addition to the default batch system (CE_BATCH_SYS_LIST), some queues may be declared
# to use another one.
# The batch system list is a dict where keys are batch systems (job managers) as specified
# in the configuration and the value the corresponding generic batch system name
# (ex: 'condor' for 'CONDOR'). For most batch systems, the key and the value are equal.
variable CE_BATCH_SYS_LIST ?= {
    SELF[CE_BATCH_SYS] = CE_BATCH_SYS;

    nondef_lrms = dict();
    if ( exists(CE_QUEUES['lrms']) && is_defined(CE_QUEUES['lrms']) ) {
        foreach (queue; lrms; CE_QUEUES['lrms']) {
            if ( !exists(SELF[lrms]) ) {
                SELF[lrms] = lrms;
            };
        };
    };

    # Update value for some specific job managers
    foreach (jobmanager; lrms; SELF) {
        if ( lrms == 'CONDOR' ) {
            SELF[jobmanager] = 'condor';
        };
    };

    debug('List of configured batch systems: ' + to_string(SELF));
    SELF;
};

# Compute number of sockets (CPUs) and cores.
# If the variable defining this for each WN based on HW configuration
# is not defined, rely on WN_CPUS variable.
variable CE_CPU_CONFIG = {
    SELF['cpus'] = 0;
    SELF['cores'] = 0;
    SELF['slots'] = 0;
    foreach (i; wn; WORKER_NODES) {
        if ( is_defined(WN_CPU_CONFIG[wn]) ) {
            SELF['cpus'] = SELF['cpus'] + WN_CPU_CONFIG[wn]['cpus'];
            SELF['cores'] = SELF['cores'] + WN_CPU_CONFIG[wn]['cores'];
            SELF['slots'] = SELF['slots'] + WN_CPU_CONFIG[wn]['slots'];
        } else {
            error('Failed to find ' + wn + ' CPU configuration in WN_CPU_CONFIG');
        };
    };
    if(SELF['cpus'] == 0){
        SELF['cpus'] = 1;
        SELF['cores'] = 1;
        SELF['slots'] = 1;
    };

    SELF;
};

# ----------------------------------------------------------------------------
# Configure GIP plugins used to update dynamic information
# ----------------------------------------------------------------------------

"/software/components/gip2/plugin" = {
    if ( is_defined(SELF) && !is_dict(SELF) ) {
        error('/software/components/gip2/plugin must be an dict');
    };

    # iterate over supported batch systems
    if ( is_defined(CE_BATCH_SYS_LIST) && (length(CE_BATCH_SYS_LIST) > 0) ) {
        contents = "";

        foreach (jobmanager; lrms; CE_BATCH_SYS_LIST) {
            if ( lrms == "condor" ) {
                # Do it only the GIP_CLUSTER_PUBLISHER_HOST, not on all CEs
                if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) {
                    if ( !is_defined(GIP_CE_CONDOR_INFO_DYNAMIC_PLUGIN) ) {
                        error('Internal error: GIP_CE_CONDOR_INFO_DYNAMIC_PLUGIN variable undefined');
                    };
                    contents = contents + "/usr/libexec/" + GIP_CE_CONDOR_INFO_DYNAMIC_PLUGIN +
                                " --scheduler " + CE_HOST +
                                " --glue1-ldif /var/lib/bdii/gip/ldif/static-file-all-CE-condor.ldif" +
                                " --glue2-ldif /var/lib/bdii/gip/ldif/ComputingShare.ldif" +
                " --ee-ldif /var/lib/bdii/gip/ldif/ExecutionEnvironment.ldif\n";
                    GIP_LDIF_DIR + "/static-file-all-CE-" + lrms + ".ldif " + CONDOR_HOST + "\n";
                };

            } else if ( lrms == "lsf" ) {
                contents = contents + LCG_INFO_SCRIPTS_DIR + "/lcg-info-dynamic-lsf /usr/local/lsf/bin/ " +
                            GIP_LDIF_DIR + "/static-file-CE-" + lrms + ".ldif" + "\n";

            } else {
                error("unrecognized batch system (" + lrms + "); can't configure gip CE information");
            };
        };

        if ( length(contents) > 0 ) {
            SELF['lcg-info-dynamic-ce'] = "#!/bin/sh\n" + contents;
        };
    };

    SELF;
};

# Plugin to compute number of running jobs and ERT
"/software/components/gip2/plugin" = {
    # iterate over supported batch systems
    if ( is_defined(CE_BATCH_SYS_LIST) && (length(CE_BATCH_SYS_LIST) > 0) ) {
        contents = "#!/bin/sh\n";

        foreach (jobmanager; lrms; CE_BATCH_SYS_LIST) {
            contents = contents + format(
                '%s/lcg-info-dynamic-scheduler -c %s/lcg-info-dynamic-scheduler-%s.conf',
                LCG_INFO_SCRIPTS_DIR,
                GIP_SCRIPTS_CONF_DIR,
                lrms,
            );
        };

        SELF['lcg-info-dynamic-scheduler-wrapper'] = contents;
    };

    SELF;
};

variable GIP_CE_VOMAP ?= {
    this = dict();
    vomap_empty = true;
    foreach (k; vo; VOS) {
        if (vo != VO_INFO[vo]['name']) {
            vomap_empty = false;
            this[vo] = VO_INFO[vo]['name'];
        };
    };
    # might brake if empty, add last if no VOs were remapped
    if (vomap_empty) {
        this[vo] = VO_INFO[vo]['name'];
    };
    this;
};

# ERT configuration
"/software/components/gip2/scripts" = {
    if ( is_defined(SELF) && !is_dict(SELF) ) {
        error('/software/components/gip2/scripts must be an dict');
    };

    # iterate over supported batch systems
    if ( is_defined(CE_BATCH_SYS_LIST) ) {
        foreach (jobmanager; lrms; CE_BATCH_SYS_LIST) {
            if ( lrms == "condor" ) {
                contents = "[Main]\n" +
                            "static_ldif_file: " + GIP_LDIF_DIR + "/static-file-all-CE-" + lrms + ".ldif\n" +
                            "vomap : \n";

                foreach (k; vo; GIP_CE_VOMAP) {
                    contents = contents + "  " + k + ":" + vo + "\n";
                };

                contents = contents +
                    "module_search_path : ../lrms:../ett\n" +
                    "[LRMS]\n" +
                    "lrms_backend_cmd: " + LCG_INFO_SCRIPTS_DIR + "/lrmsinfo-condor\n" +
                    "[Scheduler]\n" +
                    "cycle_time : 0\n";
            };

            SELF[escape(GIP_SCRIPTS_CONF_DIR + '/lcg-info-dynamic-scheduler-' + lrms + '.conf')] = contents;
        };
    };

    SELF;
};

# Plugin for software tags.
"/software/components/gip2/plugin" = {
    if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) {
        this = "#!/bin/sh\n";
        this = this + LCG_INFO_SCRIPTS_DIR + "/lcg-info-dynamic-software ";
        this = this + GIP_LDIF_DIR + "/static-file-Cluster.ldif\n";
        SELF['lcg-info-dynamic-software-wrapper'] = this;
    };
    SELF;
};


# ---------------------------------------------------------------------
# Build LDIF entries related to the CE
# ---------------------------------------------------------------------

# MPI-related SW tags
include if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) 'features/gip/mpi';

variable GIP_CE_LDIF_PARAMS = {

    # Glue cluster and subcluster information.
    # Added only if the current host is the LRMS host (GIP_CLUSTER_PUBLISHER_HOST
    # can be redefined to change this behaviour).
    # Do not create if CE_FLAVOR is undefined (not a CE).

    if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) {
        # Build service endpoint and associated foreign key for each queue based on CE type
        queue_endpoints = list();
        foreign_keys = list("GlueSiteUniqueID=" + SITE_NAME);
        foreach (queue; vos; CE_QUEUES['vos']) {
            if (exists(CE_QUEUES['lrms'][queue])) {
                jobmanager = CE_QUEUES['lrms'][queue];
                lrms = CE_BATCH_SYS_LIST[jobmanager];
            } else {
                jobmanager = CE_JM_TYPE;
                lrms = jobmanager;
            };
            foreach (i; ce; CE_HOSTS_CREAM) {

                ce_flavor = 'cream';
                if ( ce_flavor == 'cream' ) {
                    # CREAM CE doesn't know about all LCG CE job manager variants...
                    jobmanager = lrms;
                    queue_endpoints[length(queue_endpoints)] = ce + ":" + to_string(CE_PORT[ce_flavor]) +
                        "/cream-" + jobmanager + "-" + queue;
                    foreign_keys[length(foreign_keys)] = "GlueCEUniqueID=" + ce + ":" +
                        to_string(CE_PORT[ce_flavor]) + "/cream-" + jobmanager + "-" + queue;
                } else {
                    queue_endpoints[length(queue_endpoints)] = ce + ":" + to_string(CE_PORT[ce_flavor]) +
                        "/jobmanager-" + jobmanager + "-" + queue;
                    foreign_keys[length(foreign_keys)] = "GlueCEUniqueID=" + ce + ":" +
                        to_string(CE_PORT[ce_flavor]) + "/jobmanager-" +
                        jobmanager + "-" + queue;
                };
            };
        };

        cluster_entries_g1 = dict();
        cluster_entries_g1[escape(
            'dn: GlueClusterUniqueID=' + GIP_CLUSTER_PUBLISHER_HOST + ',Mds-Vo-name=resource,o=grid'
        )] = dict(
            "objectClass", list(
                'GlueClusterTop', 'GlueCluster', 'GlueInformationService', 'GlueKey', 'GlueSchemaVersion'
            ),
            "GlueClusterName", list(GIP_CLUSTER_PUBLISHER_HOST),
            "GlueForeignKey", foreign_keys,
            "GlueClusterService", queue_endpoints,
            "GlueInformationServiceURL", list(RESOURCE_INFORMATION_URL),
            "GlueSchemaVersionMajor", list("1"),
            "GlueSchemaVersionMinor", list("3"),
        );

        # For GlueHostArchitecturePlatformType, assume the same type as CE until we support several subclusters
        # per cluster.
        average_core_num = to_double(CE_CPU_CONFIG['slots']) / CE_CPU_CONFIG['cpus'];
        hepspec06 = 4 * to_double(CE_SI00) / 1000;

        cluster_entries_g1[escape(
            'dn: GlueSubClusterUniqueID=' + GIP_CLUSTER_PUBLISHER_HOST +
            ', GlueClusterUniqueID=' + GIP_CLUSTER_PUBLISHER_HOST +
            ',Mds-Vo-name=resource,o=grid'
        )] = dict(

            'objectClass', list(
                'GlueClusterTop', 'GlueSubCluster', 'GlueHostApplicationSoftware', 'GlueHostArchitecture',
                'GlueHostBenchmark', 'GlueHostMainMemory', 'GlueHostOperatingSystem', 'GlueHostProcessor',
                'GlueInformationService', 'GlueKey', 'GlueSchemaVersion'
            ),
            'GlueSubClusterUniqueID', list(GIP_CLUSTER_PUBLISHER_HOST),
            'GlueChunkKey', list('GlueClusterUniqueID=' + GIP_CLUSTER_PUBLISHER_HOST),
            'GlueHostArchitectureSMPSize', list(CE_SMPSIZE),
            'GlueHostArchitecturePlatformType', list(CE_WN_ARCH),
            'GlueHostBenchmarkSF00', list(CE_SF00),
            'GlueHostBenchmarkSI00', list(CE_SI00),
            'GlueHostMainMemoryRAMSize', list(CE_MINPHYSMEM),
            'GlueHostMainMemoryVirtualSize', list(CE_MINVIRTMEM),
            'GlueHostNetworkAdapterInboundIP', list(CE_INBOUNDIP),
            'GlueHostNetworkAdapterOutboundIP', list(CE_OUTBOUNDIP),
            'GlueHostOperatingSystemName', list(CE_OS),
            'GlueHostOperatingSystemRelease', list(CE_OS_RELEASE),
            'GlueHostOperatingSystemVersion', list(CE_OS_VERSION),
            'GlueHostProcessorClockSpeed', list(CE_CPU_SPEED),
            'GlueHostProcessorModel', list(CE_CPU_MODEL),
            'GlueHostProcessorOtherDescription', list('Cores=' + to_string(average_core_num) +
                ',Benchmark=' + to_string(hepspec06) + '-HEP-SPEC06'),
            'GlueHostProcessorVendor', list(CE_CPU_VENDOR),
            'GlueSubClusterName', list(FULL_HOSTNAME),
            'GlueSubClusterPhysicalCPUs', list(to_string(CE_CPU_CONFIG['cpus'])),
            'GlueSubClusterLogicalCPUs', list(to_string(CE_CPU_CONFIG['slots'])),
            'GlueSubClusterTmpDir', list('/tmp'),
            'GlueSubClusterWNTmpDir', list('/tmp'),
            "GlueInformationServiceURL", list(RESOURCE_INFORMATION_URL),
            'GlueHostApplicationSoftwareRunTimeEnvironment', CE_RUNTIMEENV,
            'GlueSchemaVersionMajor', list("1"),
            'GlueSchemaVersionMinor', list("3"),
        );

        SELF["glue1"]["lcg-info-static-cluster.conf"]['ldifFile'] = "static-file-Cluster.ldif";
        SELF["glue1"]["lcg-info-static-cluster.conf"]['entries'] = cluster_entries_g1;
    };


    # Glue CE static information.
    # When using GIP in cache mode and the current node is the LRMS
    # server, a second LDIF file is produced with the entries for all
    # CEs to be used as input by GIP plugin run in cache mode on the LRMS server.
    # All CEs are assumed to share the same configuration for queue state, default SE...
    # iterate over all defined queues (there is one GlueCE object per queue)
    if ( is_defined(CE_QUEUES['vos']) ) {
        # GLUE1: host_entries_g1 and all_ce_entries_g1 contain the VOView/CE DN list per LRMS
        # GLUE2: all_ce_entries_g2 contain the shares and computing service descriptions (there is no host_entries_g2)
        host_entries_g1 = dict();
        all_ce_entries_g1 = dict();
        share_entries_g2 = dict();

        foreach (queue; vos; CE_QUEUES['vos']) {
            if (exists(CE_QUEUES['lrms'][queue])) {
                jobmanager = CE_QUEUES['lrms'][queue];
            } else {
                jobmanager = CE_BATCH_SYS;
            };
            lrms = CE_BATCH_SYS_LIST[jobmanager];
            if ( !is_dict(host_entries_g1[lrms]) ) host_entries_g1[lrms] = dict();
            # FIXME: when lcg-info-dynamic-scheduler is fixed to allow publishing GlueCE/GlueVOView on the CE,
            # uncomment next line and remove the following one (initialize host_entries_g1[lrms] only if
            # GIP_CE_USE_CACHE is true).
            #if ( GIP_CE_USE_CACHE && !is_dict(host_entries_g1[lrms]) ) host_entries_g1[lrms] = dict();
            if ( !is_dict(host_entries_g1[lrms]) ) host_entries_g1[lrms] = dict();

            if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) { ##Changed LRMS_SERVER_HOST->GIP_CLUSTER_PUBLISHER_HOST
                ce_list = merge(CE_HOSTS_LCG, CE_HOSTS_CREAM);
                # Create only if necessary to avoid creating a useless emtpy file
                # FIXME: when lcg-info-dynamic-scheduler is fixed to allow publishing GlueCE/GlueVOView on the CE,
                #        initialize all_ce_entries_g1[lrms] only if GIP_CE_USE_CACHE is true.
                #        Also see the related modification at the end of this block.
                #        Issue can be followed up at https://ggus.eu/index.php?mode=ticket_info&ticket_id=110336.
                if ( !is_dict(all_ce_entries_g1[lrms]) ) all_ce_entries_g1[lrms] = dict();
                if ( !is_dict(share_entries_g2[lrms]) ) share_entries_g2[lrms] = dict();
            } else {
                ce_list = list(FULL_HOSTNAME);
            };

            foreach (i; ce; ce_list) {
                if ( index(ce, CE_HOSTS_LCG) >= 0 ) {
                    ce_flavor = 'lcg';
                    unique_id = ce + ':' + to_string(CE_PORT[ce_flavor]) + '/jobmanager-' + jobmanager + '-' + queue;
                } else {
                    ce_flavor = 'cream';
                    # On CREAM CE, there is no distinction between lcgpbs and pbs. Reset jobmanager to lrms.
                    jobmanager = lrms;
                    unique_id = ce + ':' + to_string(CE_PORT[ce_flavor]) + '/cream-' + jobmanager + '-' + queue;
                };

                access = list();
                contact = list();

                # Try to set up initial GlueCEStateStatus according to defined
                # queue state, else assume default. Assume the same state on all CEs.
                # Will be updated by GIP to reflect the exact status.
                entries_g1 = dict();
                entries_g2 = dict();
                foreach (k; vo; vos) {
                    vo_name = VO_INFO[vo]['name'];
                    rule = "VO:" + vo_name;
                    access[length(access)] = rule;

                    if ( is_defined(CE_DEFAULT_SE) ) {
                        gluese_info_default_se = dict('GlueCEInfoDefaultSE', list(CE_DEFAULT_SE));
                    } else {
                        gluese_info_default_se = dict();
                    };

                    if ( is_defined(CE_VO_DEFAULT_SE[vo]) ) {
                        gluese_info_default_se = dict('GlueCEInfoDefaultSE', list(CE_VO_DEFAULT_SE[vo]));
                    };

                    if ( is_defined(VO_INFO[vo]['swarea']['name']) ) {
                        sw_area = dict('GlueCEInfoApplicationDir', list(VO_INFO[vo]['swarea']['name']));
                    } else {
                        sw_area = dict();
                    };

                    #FIXME: use home directory if in a shared area
                    shared_data_dir = dict('GlueCEInfoDataDir', list(CE_DATADIR));

                    # GLUE1 GlueVOView entry (LDIF, 1/VO/CE)
                    entries_g1[escape('dn: GlueVOViewLocalID=' + vo_name + ',GlueCEUniqueID=' +
                                unique_id + ',Mds-Vo-name=resource,o=grid')] = merge(
                        dict(
                            'objectClass', list('GlueCETop', 'GlueVOView', 'GlueCEInfo', 'GlueCEState',
                                                'GlueCEAccessControlBase', 'GlueCEPolicy',
                                                'GlueKey', 'GlueSchemaVersion'),
                            'GlueVOViewLocalID', list(vo_name),
                            'GlueSchemaVersionMajor', list('1'),
                            'GlueSchemaVersionMinor', list('3'),
                            'GlueCEAccessControlBaseRule', list(rule),
                            'GlueCEStateRunningJobs', list('0'),
                            'GlueCEStateWaitingJobs', list(to_string(GLUE_FAKE_JOB_VALUE)),
                            'GlueCEStateTotalJobs', list('0'),
                            'GlueCEStateFreeJobSlots', list('0'),
                            'GlueCEStateEstimatedResponseTime', list('2146660842'),
                            'GlueCEStateWorstResponseTime', list('2146660842'),
                            'GlueChunkKey', list("GlueCEUniqueID=" + unique_id),
                        ),
                        gluese_info_default_se,
                        sw_area,
                        shared_data_dir,
                    );
                };

                # GLUE1 GlueCE entry (LDIF)
                entries_g1[escape('dn: GlueCEUniqueID=' + unique_id + ',Mds-Vo-name=resource,o=grid')] = merge(
                    dict(
                        'objectClass', list('GlueCETop', 'GlueCE', 'GlueCEAccessControlBase',
                                            'GlueCEInfo', 'GlueCEPolicy', 'GlueCEState',
                                            'GlueInformationService', 'GlueKey', 'GlueSchemaVersion'),
                        'GlueCEImplementationName', list(GLUE_CE_IMPLEMENTATION[ce_flavor]),
                        'GlueCEImplementationVersion', list(CREAM_CE_VERSION),
                        'GlueCEHostingCluster', list(GIP_CLUSTER_PUBLISHER_HOST),
                        'GlueCEName', list(queue),
                        'GlueCEUniqueID', list(unique_id),
                        'GlueCEInfoGatekeeperPort', list(to_string(CE_PORT[ce_flavor])),
                        # This is a hack to fix a problem affecting WMS/NagiosBox that don't like a InfoHostName
                        # that doesn't match a CE name... InfoHostName should be FULL_HOSTNAME normally.
                        'GlueCEInfoHostName', list(ce),
                        'GlueCEInfoLRMSType', list(lrms),
                        'GlueCEInfoLRMSVersion', list('not defined'),
                        'GlueCEInfoTotalCPUs', list('0'),
                        'GlueCEInfoJobManager', list(jobmanager),
                        'GlueCEInfoContactString', list(unique_id),
                        'GlueCEInfoApplicationDir', list("/home/"),
                        'GlueCEInfoDataDir', list(CE_DATADIR),
                        'GlueCEStateEstimatedResponseTime', list(to_string(2146660842)),
                        'GlueCEStateFreeCPUs', list('0'),
                        'GlueCEStateRunningJobs', list('0'),
                        'GlueCEStateStatus', list(queue_status),
                        'GlueCEStateTotalJobs', list('0'),
                        'GlueCEStateWaitingJobs', list(to_string(GLUE_FAKE_JOB_VALUE)),
                        'GlueCEStateWorstResponseTime', list('2146660842'),
                        'GlueCEStateFreeJobSlots', list('0'),
                        'GlueCEPolicyMaxCPUTime', list('0'),
                        'GlueCEPolicyMaxRunningJobs', list('0'),
                        'GlueCEPolicyMaxTotalJobs', list('0'),
                        'GlueCEPolicyMaxWallClockTime', list('0'),
                        'GlueCEPolicyPriority', list('1'),
                        'GlueCEPolicyAssignedJobSlots', list('0'),
                        'GlueCECapability', CE_CAPABILITIES,
                        'GlueForeignKey', list('GlueClusterUniqueID=' + GIP_CLUSTER_PUBLISHER_HOST),
                        'GlueInformationServiceURL', list(RESOURCE_INFORMATION_URL),
                        'GlueCEAccessControlBaseRule', access,
                        'GlueCEPolicyMaxObtainableCPUTime', list('0'),
                        'GlueCEPolicyMaxObtainableWallClockTime', list('0'),
                        'GlueCEPolicyMaxSlotsPerJob', list('0'),
                        'GlueCEPolicyPreemption', list('0'),
                        'GlueCEPolicyMaxWaitingJobs', list('0'),
                        'GlueSchemaVersionMajor', list('1'),
                        'GlueSchemaVersionMinor', list('3'),
                    ),
                    gluese_info_default_se
                );

                # Entries are for the current host, add them to the list of DN for the GIP standard LDIF file
                if ( ce == FULL_HOSTNAME ) {
                    host_entries_g1[lrms] = merge(host_entries_g1[lrms], entries_g1);
                };

                # Also add to GLUE1 LDIF file used when cache mode is enabled (several entries in ce_list)
                if ( is_dict(all_ce_entries_g1[lrms]) ) {
                    all_ce_entries_g1[lrms] = merge(all_ce_entries_g1[lrms], entries_g1);
                };

                foreach (k; vo; vos) {
                    vo_name = VO_INFO[vo]['name'];
                    # GLUE2 entry (LDIF generator config entry).
                    if(!is_defined(GLUE2_SHARES_BY_CE)||!GLUE2_SHARES_BY_CE){
                        # GLUE2 shares are independent of CEs: add only once.
                        share_name =  replace('\.', '-', format('%s_%s', queue, vo_name));
                    }else{
                        # GLUE2 shares are different by CEs as queues depends on the CEs
                        share_name =  replace('\.', '-', format('%s_%s_%s', ce, queue, vo_name));
                    };
                    if ( !is_defined(share_entries_g2[lrms][share_name]) ) {
                        glue2_var_prefix = format('SHARE_%s_', to_uppercase(share_name));
                        entries_g2[share_name] = dict(
                            glue2_var_prefix + 'QUEUENAME', list(queue),
                            glue2_var_prefix + 'OWNER', list(vo_name),
                            glue2_var_prefix + 'ENDPOINTS', list(ce + '_org.glite.ce.CREAM'),
                            glue2_var_prefix + 'EXECUTIONENVIRONMENTS', list(GIP_CLUSTER_PUBLISHER_HOST),
                            glue2_var_prefix + 'ACBRS', access,
                            glue2_var_prefix + 'CEIDS', list(unique_id),
                        );
                    };
                };

                # GLUE2 : add entries if on the LRMS master node
                if ( is_dict(share_entries_g2[lrms]) ) {
                    share_entries_g2[lrms] = merge(share_entries_g2[lrms], entries_g2);
                };


            };           # end of iteration over CEs

        };             # end of iteration over queues

        # Create LDIF configuration entries describing CE queues (GlueCE and GlueVOView).
        # FIXME: restore original behaviour when lcg-info-dynamic-scheduler is fixed
        # (https://ggus.eu/index.php?mode=ticket_info&ticket_id=110336).
        #        See other related section at the beginning of this block.
        # Due to a problem in lcg-info-dynamic-scheduler not allowing anymore to redefine
        # the static file location, everything is published on the GIP_CLUSTER_PUBLISHER_HOST as
        # there is no point to publish the same information twice on different hosts.
#    if ( index(FULL_HOSTNAME, CE_HOSTS) >= 0 ) {
#      foreach (lrms; ce_entries; host_entries_g1) {
#        conf_file_g1 = "lcg-info-static-ce-" + lrms + ".conf";
#        SELF['glue1'][conf_file_g1]['ldifFile'] = "static-file-CE-" + lrms + ".ldif";
#        if ( !is_defined(SELF['glue1'][conf_file_g1]['entries']) ) SELF['glue1'][conf_file_g1]['entries'] = dict();
#        SELF['glue1'][conf_file_g1]['entries'] = merge(SELF['glue1'][conf_file_g1]['entries'], ce_entries);
#      };
#    } else {
        if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) {
            foreach (lrms; ce_entries; all_ce_entries_g1) {
                conf_file_g1 = "lcg-info-static-all-CE-" + lrms + ".conf";
                # Use standard location for LDIF file until the lcg-info-dynamic-scheduler issue is fixed and
                # original behaviour can be restored.
                #SELF['glue1'][conf_file_g1]['ldifFile'] = GIP_VAR_DIR + "/static-file-all-CE-" + lrms + ".ldif";
                SELF['glue1'][conf_file_g1]['ldifFile'] = "static-file-all-CE-" + lrms + ".ldif";
                if ( !is_defined(SELF['glue1'][conf_file_g1]['entries']) )
                    SELF['glue1'][conf_file_g1]['entries'] = dict();
                SELF['glue1'][conf_file_g1]['entries'] = merge(SELF['glue1'][conf_file_g1]['entries'], ce_entries);
            };
        };
        foreach (lrms; share_entries; share_entries_g2) {
            conf_file_g2 = "glite-ce-glue2.conf";
            if ( !is_defined(SELF['glue2']['shares']) ) SELF['glue2']['shares'] = dict();
            SELF['glue2']['shares'] = merge(SELF['glue2']['shares'], share_entries);
        };
    };


    # Glue CE-SE binding static information.
    # Do not create if CE_FLAVOR is undefined (not a CE).

    if ( is_defined(CE_FLAVOR) ) {
        # iterate over all defined queues (there is one GlueCE object per queue)
        if ( is_defined(CE_QUEUES['vos']) ) {
            close_se_entries_g1 = dict();

            foreach (queue; vos; CE_QUEUES['vos']) {
                if (exists(CE_QUEUES['lrms'][queue])) {
                    jobmanager = CE_QUEUES['lrms'][queue];
                } else {
                    jobmanager = CE_BATCH_SYS;
                };
                lrms = CE_BATCH_SYS_LIST[jobmanager];

                if ( CE_FLAVOR == 'cream' ) {
                    # On CREAM CE, there is no distinction between lcgpbs and pbs. Reset jobmanager to lrms.
                    jobmanager = lrms;
                    unique_id = FULL_HOSTNAME + ':' + to_string(CE_PORT[CE_FLAVOR]) +
                        '/cream-' + jobmanager + '-' + queue;
                } else {
                    unique_id = FULL_HOSTNAME + ':' + to_string(CE_PORT[CE_FLAVOR]) +
                        '/jobmanager-' + jobmanager + '-' + queue;
                };

                # Compute close SE list for the current queue by doing union of close SE
                # for all VO authorized to access the queue.
                # CE_VO_CLOSE_SE contains one entry per VO supported on the CE.
                se_dict = dict();
                foreach (i; vo; vos) {
                    se_list = CE_VO_CLOSE_SE[vo];
                    if ( is_defined(se_list) ) {
                        foreach (i; v; se_list) {
                            se_dict[v] = 1;        # Value is useless
                        };
                    };
                };
                queue_close_se_list = list();
                if ( length(se_dict) > 0 ) {
                    foreach (se; v; se_dict) {
                        queue_close_se_list[length(queue_close_se_list)] = se;
                    };
                };

                # Define list of SEs usable by this queue
                if ( length(queue_close_se_list) > 0 ) {
                    close_se_entries_g1[escape('dn: GlueCESEBindGroupCEUniqueID=' + unique_id +
                                        ',Mds-Vo-name=resource,o=grid')] = dict(
                        'objectClass', list('GlueGeneralTop', 'GlueCESEBindGroup', 'GlueSchemaVersion'),
                        'GlueCESEBindGroupSEUniqueID', queue_close_se_list,
                        'GlueSchemaVersionMajor', list('1'),
                        'GlueSchemaVersionMinor', list('3'),
                    );
                };

                # Define a GlueCESEBindSEUniqueID per SE usable from the queue (close SE list).
                # Some SEs may not be managed locally and thus not be listed into SE_HOSTS.
                foreach (i; se; queue_close_se_list) {
                    if ( exists(SE_HOSTS[se]) ) {
                        params = SE_HOSTS[se];
                    } else {
                        params = undef;
                    };

                    if ( exists(params['accessPoint']) && is_defined(params['accessPoint']) ) {
                        accesspoint = params['accessPoint'];
                    } else {
                        if ( params['type'] == 'SE_dpm' ) {
                            toks = matches(se, '^([\w\-]+\.)(.*)$');
                            if ( length(toks) != 3 ) {
                                error('Invalid SE host name (' + se + ')');
                            };
                            accesspoint = '/dpm/' + toks[2] + '/home';
                        } else if ( params['type'] == 'SE_classic' ) {
                            accesspoint = SE_STORAGE_DIR;
                        } else {
                            error('No default value for SE Access Point for host ' +
                                se + ' (type=' + params['type'] + ')');
                        };
                    };

                    close_se_entries_g1[escape('dn: GlueCESEBindSEUniqueID=' + se + ',GlueCESEBindGroupCEUniqueID=' +
                        unique_id + ',Mds-Vo-name=resource,o=grid')] = dict(
                        'objectClass', list('GlueGeneralTop', 'GlueCESEBind', 'GlueSchemaVersion'),
                        'GlueSchemaVersionMajor', list('1'),
                        'GlueSchemaVersionMinor', list('3'),
                        'GlueCESEBindGroupCEUniqueID', list(unique_id),
                        'GlueCESEBindCEAccesspoint', list(accesspoint),
                        'GlueCESEBindCEUniqueID', list(unique_id),
                        'GlueCESEBindMountInfo', list(accesspoint),
                        'GlueCESEBindWeight', list('0'),
                    );

                };
            };
        };

        SELF["glue1"]["lcg-info-static-cesebind.conf"]['ldifFile'] = "static-file-CESEBind.ldif";
        SELF["glue1"]["lcg-info-static-cesebind.conf"]['entries'] = close_se_entries_g1;
    };


    # Create LDIF configuration entries for GLUE2 (general parameters)
    # FIXME: ServingState configuration
    # FIXME: Argus paramater based on actual config
    # FIXME: CE_BATCH_VERSION paramater based on actual config
    # FIXME: CloseSEs: set LocalPath/RemotePath
    # FIXME: manage ESComputingServiceID and WorkingAreaxxx attributes
    ce_acbr = list();
    foreach (i; vo; VOS) {
        ce_acbr[length(ce_acbr)] = format('VO:%s', vo);
    };
    ce_shares = list();
    foreach (lrms; share_entries; share_entries_g2) {
        foreach (share; params; share_entries) {
            ce_shares[length(ce_shares)] = to_uppercase(share);
        }
    };
    ce_close_ses = list();
    if ( is_defined(queue_close_se_list) ) {
        foreach (i; se; queue_close_se_list) {
            ce_close_ses[length(ce_close_ses)] = format('(%s none none)', se);
        };
    };
    if ( CE_SHARED_HOMES ) {
        working_area_shared = 'yes';
    } else {
        working_area_shared = 'no';
    };
    # FIXME: check what ImplementationVersion and InterfaceVersion should be (CE version or LRMS version)
    SELF['glue2']['CEParameters'] = dict(
        'SiteId', list(SITE_NAME),
        'ComputingServiceId', list(LRMS_PRIMARY_SERVER_HOST + '_ComputingElement'),
        'NumberOfEndPointType', list('3'),
        'ImplementationVersion', list(CREAM_CE_VERSION),
        'InterfaceVersion', list(CREAM_CE_VERSION),
        'HealthStateHelper', list(GIP_PROVIDER_SUBSERVICE['test']),
        'ServingState', list('production'),
        'Owner', VOS,
        'Argus', list('no'),
        'EMIES', list('no'),
        'ACBR', ce_acbr,
        'Shares', ce_shares,
        'ExecutionEnvironments', list(GIP_CLUSTER_PUBLISHER_HOST),
        'CE_BATCH_SYS', list(CE_BATCH_SYS),
        'BATCH_VERSION', list('0.0.0.0'),
        'CECapabilities', CE_CAPABILITIES,
        'CloseSEs', ce_close_ses,
        'WorkingAreaShared', list(working_area_shared),
        #'WorkingAreaGuaranteed', list('no'),
        #'WorkingAreaTotal', list('undefined'),
        #'WorkingAreaFree', list('undefined'),
        #'WorkingAreaLifeTime', list('undefined'),
        #'WorkingAreaMultislotTotal', list('undefined'),
        #'WorkingAreaMultislotFree', list('undefined'),
        #'WorkingAreaMultislotLifeTime', list('undefined'),
        #'ESComputingServiceId', list('undefined'),
    );


    # Create LDIF configuration entries for GLUE2 (execution environment parameters)
    # FIXME: SmpSize, Cores. Define separate Execution Environments for different HW?
    # FIXME: ProcessorVendor. Define separate Execution Environments for different HW?
    # FIXME: ProcessorModel. Define separate Execution Environments for different HW?
    # FIXME: ProcessorClockSpeed. Define separate Execution Environments for different HW?
    if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) {
        glue2_var_prefix = format('ExecutionEnvironment_%s_', GIP_CLUSTER_PUBLISHER_HOST);
        SELF['glue2']['ExecutionEnvironment'] = dict(
            glue2_var_prefix + 'ArchitecturePlatformType', list(CE_WN_ARCH),
            glue2_var_prefix + 'PhysicalCPUs', list(to_string(CE_CPU_CONFIG['cpus'])),
            glue2_var_prefix + 'LogicalCPUs', list(to_string(CE_CPU_CONFIG['slots'])),
            glue2_var_prefix + 'SmpSize', list(CE_SMPSIZE),
            glue2_var_prefix + 'ProcessorVendor', list(CE_CPU_VENDOR),
            glue2_var_prefix + 'ProcessorModel', list(CE_CPU_MODEL),
            glue2_var_prefix + 'ProcessorClockSpeed', list(CE_CPU_SPEED),
            glue2_var_prefix + 'MainMemoryRAMSize', list(CE_MINPHYSMEM),
            glue2_var_prefix + 'MainMemoryVirtualSize', list(CE_MINVIRTMEM),
            glue2_var_prefix + 'OperatingSystemFamily', list(CE_OS_FAMILY),
            glue2_var_prefix + 'OperatingSystemName', list(CE_OS),
            glue2_var_prefix + 'OperatingSystemRelease', list(CE_OS_RELEASE),
            glue2_var_prefix + 'NetworkAdapterInboundIP', list(CE_INBOUNDIP),
            glue2_var_prefix + 'NetworkAdapterOutboundIP', list(CE_OUTBOUNDIP),
            glue2_var_prefix + 'Benchmarks', list(
                format('(hep-spec06 %s)', to_string(hepspec06)),
                format('(specfp2000 %s)', to_string(CE_SF00)),
                format('(specint2000 %s)', to_string(CE_SI00)),
            ),
            glue2_var_prefix + 'Cores', list(to_string(average_core_num)),
        );
    };

    SELF;
};


#--------------------------------------------------------------------
# Copy GIP_CE_LDIF_PARAMS to the relevant part of the configuration.
# LDIF configuration is done differently for GLUE1 and GLUE2.
#--------------------------------------------------------------------
"/software/components/gip2" = {
    if ( is_defined(SELF) && !is_dict(SELF) ) {
        error('/software/components/gip2/ldif must be an dict');
    };

    if ( is_defined(GIP_CE_LDIF_PARAMS['glue1']) ) {
        foreach (k; v; GIP_CE_LDIF_PARAMS['glue1']) {
            SELF['ldif'][k] = v;
        };
    };

    if ( is_defined(GIP_CE_LDIF_PARAMS['glue2']) ) {
        foreach (k; v; GIP_CE_LDIF_PARAMS['glue2']) {
            if ( k == 'shares' ) {
                foreach (k2; v2; GIP_CE_LDIF_PARAMS['glue2']['shares']) {
                    SELF['ldifConfEntries'][GIP_CE_GLUE2_CONFIG_FILE][k2] = v2;
                };
            } else if ( match('CEParameters|ExecutionEnvironment', k) ) {
                SELF['ldifConfEntries'][GIP_CE_GLUE2_CONFIG_FILE][k] = GIP_CE_LDIF_PARAMS['glue2'][k]
            };
        };
        foreach (category; dummy; GIP_CE_GLUE2_LDIF_PROCESSORS) {
            # When the host is not also the GIP_CLUSTER_PUBLISHER_HOST (in cluster mode),
            # only the GLUE2ComputingService and the GLUE2ComputingEndpoint must be published.
            if ( (FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST) || match('endpoint|service', category) ) {
                SELF['ldif']['glue2_' + category]['staticInfoCmd'] = format(
                    '%s/%s',
                    GIP_CE_GLUE2_LDIF_PROCESSOR_DIR,
                    GIP_CE_GLUE2_LDIF_PROCESSORS[category]
                );
                SELF['ldif']['glue2_' + category]['confFile'] = GIP_CE_GLUE2_CONFIG_FILE;
                SELF['ldif']['glue2_' + category]['ldifFile'] = GIP_CE_GLUE2_LDIF_FILES[category];
            };
        };
    };

    SELF;
};


#---------------------------------------------------------------
# Configuration of the GlueService information provider for
# CREAM CE and CEMON service.
# Do not create if CE_FLAVOR is undefined (not a CE).
#---------------------------------------------------------------

"/software/components/gip2" = {
    if ( (is_defined(CE_FLAVOR) && is_defined(GIP_CE_SERVICES[CE_FLAVOR])) ||
        (FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST) ) {
        if ( is_defined(CE_FLAVOR) ) {
            service_list = GIP_CE_SERVICES[CE_FLAVOR];
        } else {
            service_list = list()
        };
        if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) {
            service_list[length(service_list)] = 'rtepublisher';
        };
        foreach (i; service; service_list) {
            service_owner_cmd = '';
            service_acbr_cmd = '';
            foreach (i; vo; VOS_FULL) {
                service_owner_cmd = service_owner_cmd + ' echo ' + vo + ";";
                service_acbr_cmd = service_acbr_cmd + ' echo VO:' + vo + ";";
            };
            service_provider_conf = GIP_PROVIDER_SERVICE_CONF_BASE + '-' + service + '.conf';
            service_provider_wrapper = 'glite-info-service-' + service;
            service_uniqueid = FULL_HOSTNAME + '_' + GIP_CE_SERVICE_PARAMS[service]['type'];
            if ( is_defined(GIP_CE_SERVICE_PARAMS[service]['version']) ) {
                service_version_cmd = GIP_CE_SERVICE_PARAMS[service]['version'];
            } else if ( is_defined(GIP_CE_SERVICE_PARAMS[service]['version_rpm']) ) {
                service_version_cmd = "rpm -q --qf %{V} " + GIP_CE_SERVICE_PARAMS[service]['version_rpm'];
            } else {
                error("Either 'version' or 'version_rpm' must be present in GIP_CE_SERVICE_PARAMS[" + service + "]");
            };

            SELF['confFiles'][escape(service_provider_conf)] =
                "init = " + GIP_PROVIDER_SUBSERVICE[service] + " init\n" +
                "service_type = " + GIP_CE_SERVICE_PARAMS[service]['type'] + "\n" +
                "get_version = " + service_version_cmd + "\n" +
                "get_endpoint = echo " + GIP_CE_SERVICE_PARAMS[service]['endpoint'] + "\n" +
                "get_status = " + GIP_PROVIDER_SUBSERVICE['test'] + " " +
                    GIP_CE_SERVICE_PARAMS[service]['service_status_name'] +
                    " && /sbin/service " + GIP_CE_SERVICE_PARAMS[service]['service'] + " status\n" +
                "WSDL_URL = " + GIP_CE_SERVICE_PARAMS[service]['wsdl'] + "\n" +
                "semantics_URL = " + GIP_CE_SERVICE_PARAMS[service]['semantics'] + "\n" +
                "get_starttime =  perl -e '@st=stat(" + GIP_CE_SERVICE_PARAMS[service]['pid_file'] +
                    ");print \"@st[10]\\n\";'\n" +
                "get_owner =" + service_owner_cmd + "\n" +
                "get_acbr =" + service_acbr_cmd + "\n" +
                "get_data =  echo -en " + GIP_CE_SERVICE_PARAMS[service]['service_data'] + "\n" +
                "get_implementationname = echo " + GIP_CE_SERVICE_PARAMS[service]['implementationname'] + "\n" +
                "get_implementationversion = " + service_version_cmd + "\n" +
                "get_services = echo\n";
            SELF['provider'][service_provider_wrapper] =
                "#!/bin/sh\n" +
                GIP_PROVIDER_SERVICE + ' ' + service_provider_conf + ' ' + SITE_NAME + ' ' + service_uniqueid + "\n";

            # Glue v2
            SELF['provider'][service_provider_wrapper + '-glue2'] =
                "#!/bin/sh\n" +
                GIP_PROVIDER_SERVICE + '-glue2 ' + service_provider_conf + ' ' + SITE_NAME + ' ' +
                    service_uniqueid + "\n";
        };
    };
    SELF;
};


# Define permissions/owner for some key directories
include 'components/dirperm/config';
'/software/components/dirperm/paths' = {
    append(dict(
        'owner', 'ldap:ldap',
        'path', '/var/lib/bdii/db/grid',
        'perm', '0755',
        'type', 'd',
    ));
    append(dict(
        'owner', 'ldap:ldap',
        'path', '/var/lib/bdii/db/glue',
        'perm', '0755',
        'type', 'd',
    ));
    append(dict(
        'owner', 'ldap:ldap',
        'path', '/var/lib/bdii/db/stats',
        'perm', '0755',
        'type', 'd',
    ));
};
