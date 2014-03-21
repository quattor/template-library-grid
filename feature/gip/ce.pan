unique template feature/gip/ce;

prefix '/software/packages';
'{lcg-info-dynamic-maui}'          = nlist();
'{lcg-info-dynamic-scheduler-pbs}' = nlist();

'/software/components/gip2/staticInfoCmd' = '/usr/sbin/glite-info-static-create';

"/software/components/symlink/links" = {
  SELF[length(SELF)] =   nlist("name", "/opt/lcg/lib/python",
                               "target", "/usr/lib/python",
                               "replace", nlist("all","yes"),
                              );  
  SELF;
};

include { 'components/filecopy/config' };
'/software/components/filecopy/services/{/usr/sbin/glite-info-static-create}'=
  nlist('config',"#!/bin/bash \n cat $2",
        'perms' ,'0755',
        'owner' ,'root');

include { 'components/gip2/config' };

@{
desc = define VO shares to be applied to each CE
values = percentage 
default = none
required = no
}
variable CE_VO_SHARES ?= undef;

variable CREAM_CE_VERSION ?= '1.14.0';


variable CE_HOSTS_CREAM ?= list();
variable CE_HOSTS_LCG ?= list();

variable CE_FLAVOR ?= if ( is_defined(CE_HOSTS_CREAM) && (index(FULL_HOSTNAME,CE_HOSTS_CREAM) >= 0) ) {
                        'cream';
                      } else if ( is_defined(CE_HOSTS_LCG) && (index(FULL_HOSTNAME,CE_HOSTS_LCG) >= 0) ) {
                        'lcg';
                      } else {
                        undef;
                      };
variable CE_FLAVOR = {
  if ( is_defined(CE_FLAVOR) && !match(CE_FLAVOR,'cream|lcg') ) {
    error("Invalid value for CE_FLAVOR ("+CE_FLAVOR+"). Must be 'lcg' or 'cream'.");
  };
  SELF;
};

# Default static value for several job-related attributes (updated by dynamic info providers)
variable GLUE_FAKE_JOB_VALUE ?= 4444;

# Host publishing GlueCluster and GlueSubCluster information.
# This is important to ensure this is published once even though
# several CEs share the same cluster/WNs.
# Default: LRMS master node.
variable GIP_CLUSTER_PUBLISHER_HOST ?= LRMS_SERVER_HOST;

# Variables related to MAUI-based GIP plugin.
# Enable/disable its use instead of Torque-based plugin. Default: enabled.
# Ignored if the LRMS is not pbs.
variable GIP_CE_USE_MAUI ?= true;


variable PKG_ARCH_TORQUE_MAUI ?= PKG_ARCH_GLITE;

# File for caching GIP plugin output when it is run independenly of the GIP. This is particularly useful
# when running multiple CEs in front of the same cluster. In this case, the GIP plugins are generally run as
# part of maui-monitoring script (run as a cron job on the MAUI server). Enabled with variable GIP_CE_USE_CACHE.
# As this file must normally be shared by several machines if there are several CEs, place it in the dteam
# SW area if explicitly defined else at the root of the default SW area location.
# There are 2 entries in GIP_CE_CACHE_FILE : 1 for the 'dynamic-ce' plugin, 1 for the 'dynamic-scheduler'
# plugin. There must be at least one entry for each one present in GIP_CE_PLUGIN_COMMAND.
# NOTE: this feature is currently implemented only for MAUI-based plugins.
variable GIP_CE_CACHE_FILE ?= if ( GIP_CE_USE_CACHE ) {
                                if ( ( length(CE_HOSTS) == 1 ) && ( LRMS_SERVER_HOST == CE_HOSTS[0] ) ) {
                                  SELF['ce'] = '/tmp/gip-ce-dynamic-info-maui.cache';
                                  SELF['scheduler'] = '/tmp/gip-ce-dynamic-info-scheduler.cache';
                                } else {
                                  if ( is_defined(VO_SW_AREAS['dteam']) ) {
                                    SELF['ce'] = VO_SW_AREAS['dteam']+'/gip-ce-dynamic-info-maui.cache';
                                    SELF['scheduler'] = VO_SW_AREAS['dteam']+'/gip-ce-dynamic-info-scheduler.cache';
                                  } else if ( is_defined(VO_SW_AREAS['DEFAULT']) ) {
                                    SELF['ce'] = VO_SW_AREAS['DEFAULT']+'/gip-ce-dynamic-info-maui.cache';
                                    SELF['scheduler'] = VO_SW_AREAS['DEFAULT']+'/gip-ce-dynamic-info-scheduler.cache';
                                  } else {
                                    error("Unabled to compute default value for GIP_CE_CACHE_FILE. Define explicitly");
                                  };
                                };
                                SELF;
                              } else {
                                undef;
                              };


# CE close SE list
variable CE_CLOSE_SE_LIST ?= undef;

# CE port for each CE flavor
variable CE_PORT = nlist(
  'cream', 8443,
  'lcg', 2119,
);

# For GlueHostArchitecturePlatformType, assume the same type as CE until we support several subclusters
# per cluster.
variable CE_WN_ARCH ?= PKG_ARCH_DEFAULT;

# CE implementation for each flavor
variable GLUE_CE_IMPLEMENTATION = nlist(
  'cream',    'CREAM',
  'lcg',      'LCG-CE',
);

# GIP service provider configuration.
# The value of GIP_PROVIDER_SERVICE_CONF_BASE is used as the base file name for the config file.
# GIP_CE_SERVICES defines the list of GlueService to publish for each CE flavor: there must be one matching
# entry for each value in GIP_CE_SERVICE_PARAMS.
variable GIP_PROVIDER_SERVICE_CONF_BASE ?= GIP_SCRIPTS_CONF_DIR + '/glite-info-service';
variable GIP_CE_SERVICES = nlist(
  'cream',    list('creamce','cemon'),
  'lcg',      list('gatekeeper'),
);
variable GIP_PROVIDER_SUBSERVICE ?= nlist(
  'creamce',    GIP_SCRIPTS_DIR + '/glite-info-service-cream',
  'cemon',      GIP_SCRIPTS_DIR + '/glite-info-service-cream',
  'gatekeeper', GIP_SCRIPTS_DIR + '/glite-info-service-gatekeeper',
  'rtepublisher', GIP_SCRIPTS_DIR + '/glite-info-service-rtepublisher',
  'test',       GIP_SCRIPTS_DIR + '/glite-info-service-test',
);
variable GIP_CE_SERVICE_PARAMS = nlist(
  'creamce',      nlist('type', 'org.glite.ce.CREAM',
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
  'cemon',        nlist('type', 'org.glite.ce.Monitor',
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
  'gatekeeper',   nlist('type', 'org.edg.gatekeeper',
                        'endpoint', 'gram://$GATEKEEPER_HOST:$GATEKEEPER_PORT/',
                        'service', 'globus-gatekeeper',
                        'service_status_name', 'GATEKEEPER',
                        'version', '2.0.0',
                        'pid_file', '$ENV{GATEKEEPER_PROCDIR}',
                        'wsdl', 'nohttp://not.a.web.service/',
                        'semantics', 'http://www.globus.org/toolkit/docs/2.4/gram/',
                        'service_data', '"Services=$GATEKEEPER_SERVICES\nDN=" && grid-cert-info -file /etc/grid-security/hostcert.pem -subject',
                        'implementationname', 'GateKeeper',
                       ),
  'rtepublisher', nlist('type', 'org.glite.RTEPublisher',
                      'endpoint', 'gsiftp://$RTEPUBLISHER_HOST:$RTEPUBLISHER_PORT'+VO_SW_TAGS_DIR,
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
# Compute several variables summarizing the configuration
# ---------------------------------------------------------------------------- 

variable CE_DATADIR ?= 'unset';

#Build  GlueCECapability entry to publish
variable CE_CAPABILITIES = {
      SELF[length(SELF)] = 'CPUScalingReferenceSI00='+to_string(CE_SI00);
      if ( is_defined(CE_VO_SHARES) ) {
        foreach (i;v;CE_VO_SHARES) {
          SELF[length(SELF)] = 'Share='+i+":"+to_string(v);
        };
      };
      SELF;
};


variable CE_STATE_STATUS =
  if ( exists(CE_STATUS) && is_defined(CE_STATUS) ) {
    CE_STATUS;
  } else {
    'Production';
  };

# Default queue configuration if not explicitly defined before.
# This will create one queue per VO with the queue name equal
# to the VO name and an empty 'attlist' for each queue.
# The format is a nlist made of 2 nlists : 'vos' lists for each queue
# the VO with an access to it and 'attlist' lists for each queue the
# specific queue attributes.
variable CE_QUEUES ?= {
  queues = nlist();
  queues['vos'] = nlist();
  queues['attlist'] = nlist();

  foreach (k;v;VOS) {
    queues['vos'][v] = list(v);
  };
  queues;
};

# List of batch system configured.
# In addition to the default batch system (CE_BATCH_SYS_LIST), some queues may be declared
# to use another one.
# The batch system list is a nlist where keys are batch systems (job managers) as specified
# in the configuration and the value the corresponding generic batch system name
# (ex: 'pbs' for 'lcgpbs'). For most batch systems, the key and the value are equal.
variable CE_BATCH_SYS_LIST ?= {
  SELF[CE_BATCH_SYS] = CE_BATCH_SYS;

  nondef_lrms=nlist();
  if ( exists(CE_QUEUES['lrms']) && is_defined(CE_QUEUES['lrms']) ) {
    foreach (queue;lrms;CE_QUEUES['lrms']) {
      if ( !exists(SELF[lrms]) ) {
        SELF[lrms] = lrms;
      };
    };
  };
  
  # Update value for some specific job managers
  foreach (jobmanager;lrms;SELF) {
    if ( match(lrms, 'lcgpbs|torque') ) {
      SELF[jobmanager] = 'pbs';
    } else if ( lrms == 'CONDOR' ) {
      SELF[jobmanager] = 'condor';
    };
  };

  debug('List of configured batch systems: '+to_string(SELF));
  SELF;
};

# Compute number of sockets (CPUs) and cores.
# If the variable defining this for each WN based on HW configuration
# is not defined, rely on WN_CPUS variable.
variable CE_CPU_CONFIG = {
  SELF['cpus'] = 0;
  SELF['cores'] = 0;
  foreach (i;wn;WORKER_NODES) {
    if ( is_defined(WN_CPU_CONFIG[wn]) ) {
      SELF['cpus'] = SELF['cpus'] + WN_CPU_CONFIG[wn]['cpus'];
      SELF['cores'] = SELF['cores'] + WN_CPU_CONFIG[wn]['cores'];
    } else {
      error('Failed to find '+wn+' CPU configuration in WN_CPU_CONFIG');
    };
  };
  SELF;
};
   
# Build the command to use to run the MAUI-based GIP plugins. Depending if it is run directly by the GIP or
# used in cache mode, this wrapper will be configured as a GIP plugin or as a script to be run by some other
# scripts (generally maui-monitoring).
# There are 2 entries in GIP_CE_PLUGIN_COMMAND : 1 for the 'dynamic-ce' plugin, 1 for the 'dynamic-scheduler'
# plugin.
# NOTE: this feature is currently implemented only for MAUI-based plugins.
variable GIP_CE_PLUGIN_COMMAND = {
  # If using the standard Torque-based plugin, do nothing
  if ( GIP_CE_USE_MAUI ) {
    # MAUI-based plugin requires an architecture-dependent python module.
    # To allow Torque 32-bit on an OS 64-bit, select python version to use
    # explictly in the wrapper. Assume /opt/glite/bin/python2 is configured properly to
    # launch the 32-bit version on a 64-bit OS.
    if ( (PKG_ARCH_DEFAULT == 'x86_64') && (PKG_ARCH_TORQUE_MAUI == 'i386') ) {
      pythonbin = EMI_LOCATION+'/bin/python2';
    } else {
      pythonbin = 'python'
    };
    gip_script_options = "--max-normal-slots " + to_string(CE_CPU_CONFIG['cores']);
    SELF['ce'] = pythonbin + ' ' + LCG_INFO_SCRIPTS_DIR + "/lcg-info-dynamic-maui --host "+LRMS_SERVER_HOST+" "+gip_script_options;
    if ( GIP_CE_USE_CACHE ) {
      SELF['ce'] = SELF['ce'] + ' --ce-ldif ' + GIP_VAR_DIR + '/static-file-all-CE-pbs.ldif';
    } else {
      SELF['ce'] = SELF['ce'] + ' --ce-ldif ' + GIP_LDIF_DIR + '/static-file-CE-pbs.ldif';
    };
  };

  # Define only if using cache mode
  if ( GIP_CE_USE_CACHE ) {
    SELF['scheduler'] = LCG_INFO_SCRIPTS_DIR + "/lcg-info-dynamic-scheduler -c "+
                                    GIP_SCRIPTS_CONF_DIR+"/lcg-info-dynamic-scheduler-pbs.conf";
  };
  
  SELF;
};


# ---------------------------------------------------------------------------- 
# Configure GIP plugins used to update dynamic information
# ---------------------------------------------------------------------------- 

"/software/components/gip2/plugin" = {
  if ( is_defined(SELF) && !is_nlist(SELF) ) {
    error('/software/components/gip2/plugin must be an nlist');
  };
  
  # iterate over supported batch systems
  if ( is_defined(CE_BATCH_SYS_LIST) && (length(CE_BATCH_SYS_LIST) > 0) ) {
    contents = "#!/bin/sh\n";

    foreach (jobmanager;lrms;CE_BATCH_SYS_LIST) {
      if ( lrms == "condor" ) {
        contents = contents + LCG_INFO_SCRIPTS_DIR +"/lcg-info-dynamic-condor /opt/condor/bin/ "+
            GIP_LDIF_DIR + "/static-file-CE-"+lrms+".ldif "+CONDOR_HOST+"\n";
      } else if ( lrms == "lsf" ) {
        contents = contents + LCG_INFO_SCRIPTS_DIR +"/lcg-info-dynamic-lsf /usr/local/lsf/bin/ "+
            GIP_LDIF_DIR + "/static-file-CE-"+lrms+".ldif"+"\n";
      } else if ( lrms == "remotepbs" ) {
        contents = contents + LCG_INFO_SCRIPTS_DIR +"/lcg-info-dynamic-remotepbs "+REMOTEPBS_REMOTE_HOST+
                                                                             " "+REMOTEPBS_REMOTE_PORT+"\n";   
      } else if ( lrms == "pbs" ) {
        # When using MAUI-based GIP plugin, GIP wrapper runs the plugin directly if not using the cache mode
        # or just read the cache file if used in cache mode.
        if ( GIP_CE_USE_MAUI ) {
          if ( GIP_CE_USE_CACHE ) {
            # Just display the content. If the file doesn't exist, error will be detected/reported by GIP.
            contents = contents + 'cat ' + GIP_CE_CACHE_FILE['ce'];
          } else {
            contents = contents + "export PYTHONPATH=$PYTHONPATH:/usr/lib/python\n"+ GIP_CE_PLUGIN_COMMAND['ce'];
          };
        } else {
            if ( is_defined(LRMS_SERVER_HOST) ) {
                contents = contents + LCG_INFO_SCRIPTS_DIR +"/lcg-info-dynamic-pbs " + GIP_LDIF_DIR + "/static-file-CE-"+lrms+".ldif "+LRMS_SERVER_HOST+"\n";
            } else {
      	        contents = contents + LCG_INFO_SCRIPTS_DIR +"/lcg-info-dynamic-pbs " + GIP_LDIF_DIR + "/static-file-CE-"+lrms+".ldif "+CE_HOST+"\n";  
            };
        };
      } else {
        error("unrecognized batch system ("+lrms+"); can't configure gip CE information");
      };
    };

    SELF['lcg-info-dynamic-ce'] = contents;
  };

  SELF;
};

# Plugin to compute number of running jobs and ERT 
"/software/components/gip2/plugin" = {
  # iterate over supported batch systems
  if ( is_defined(CE_BATCH_SYS_LIST) && (length(CE_BATCH_SYS_LIST) > 0) ) {
    contents = "#!/bin/sh\n";

    foreach (jobmanager;lrms;CE_BATCH_SYS_LIST) {
      if ( lrms == "remotepbs" ) {
        contents = contents + LCG_INFO_SCRIPTS_DIR + "/lcg-info-dynamic-remotepbs "+REMOTEPBS_REMOTE_HOST+" "+REMOTEPBS_REMOTE_PORT_SCHED+"\n";
      } else if ( (lrms == 'pbs') && (is_defined(GIP_CE_PLUGIN_COMMAND['scheduler'])) && GIP_CE_USE_CACHE ) {
        # Just display the content of cache file if cache mode is used. If the file doesn't exist, error will be detected/reported by GIP.
        contents = contents + 'cat ' + GIP_CE_CACHE_FILE['scheduler'];
      } else {
        contents = contents + LCG_INFO_SCRIPTS_DIR + "/lcg-info-dynamic-scheduler -c "+
                                                  GIP_SCRIPTS_CONF_DIR+"/lcg-info-dynamic-scheduler-"+lrms+".conf\n";
      };
    };

    SELF['lcg-info-dynamic-scheduler-wrapper'] = contents;
  };

  SELF;
};

variable GIP_CE_VOMAP ?= {
    this = nlist();
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
  if ( is_defined(SELF) && !is_nlist(SELF) ) {
    error('/software/components/gip2/scripts must be an nlist');
  };

  # iterate over supported batch systems
  if ( is_defined(CE_BATCH_SYS_LIST) ) {
    foreach (jobmanager;lrms;CE_BATCH_SYS_LIST) {
      if ( lrms == "pbs" ) {
        if ( GIP_CE_USE_CACHE ) {
          ldif_file = GIP_VAR_DIR + "/static-file-all-CE-pbs.ldif\n";
          ldif_file_glue2 = GIP_VAR_DIR + "/static-file-all-CE-pbs-glue2.ldif\n";
        } else {
          ldif_file = GIP_LDIF_DIR + "/static-file-CE-pbs.ldif\n";
          ldif_file_glue2 = GIP_VAR_DIR + "/static-file-CE-pbs-glue2.ldif\n";
        };
        contents = 
          "[Main]\n" + 
          "static_ldif_file: "+ ldif_file +
          "static_glue2_ldif_file_computingshare: "+ldif_file_glue2 +
          "vomap : \n";
   
        foreach (k; vo; GIP_CE_VOMAP) {
          contents = contents + "  " + k + ":" + vo + "\n";
        };
     
        contents = contents + 
          "module_search_path : ../lrms:../ett\n" + 
          "[LRMS]\n" + 
          "lrms_backend_cmd: "+ LCG_INFO_SCRIPTS_DIR + "/lrmsinfo-pbs\n" + 
          "[Scheduler]\n" + 
          "cycle_time : 0\n" + 
          "vo_max_jobs_cmd: "+ LCG_INFO_SCRIPTS_DIR + "/vomaxjobs-maui\n";
  
      } else if ( lrms == "condor" ) {
        contents = 
          "[Main]\n" + 
          "static_ldif_file: " + GIP_LDIF_DIR + "/static-file-CE-"+lrms+".ldif\n" + 
          "vomap : \n";
   
        foreach (k; vo; GIP_CE_VOMAP) {
          contents = contents + "  " + k + ":" + vo + "\n";
        };
  
        contents = contents + 
          "module_search_path : ../lrms:../ett\n" + 
          "[LRMS]\n" + 
          "lrms_backend_cmd: "+ LCG_INFO_SCRIPTS_DIR + "/lrmsinfo-condor\n" + 
          "[Scheduler]\n" + 
          "cycle_time : 0\n";
      };
      
      SELF[escape(GIP_SCRIPTS_CONF_DIR+'/lcg-info-dynamic-scheduler-'+lrms+'.conf')] = contents;
    };
  };
  
  SELF;
};

# Plugin for software tags.
"/software/components/gip2/plugin" = {
  SELF['lcg-info-dynamic-software-wrapper'] = "#!/bin/sh\n" + 
                                              LCG_INFO_SCRIPTS_DIR + "/lcg-info-dynamic-software "+
                                              GIP_LDIF_DIR + "/static-file-Cluster.ldif\n";

  SELF;
};


# ---------------------------------------------------------------------
# Glue cluster and subcluster information.
# Added only if the current host is the LRMS host (GIP_CLUSTER_PUBLISHER_HOST
# can be redefined to change this behaviour).
# Do not create if CE_FLAVOR is undefined (not a CE).
# ---------------------------------------------------------------------

# MPI-related SW tags
include { if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) 'feature/gip/mpi' };

"/software/components/gip2/ldif" = {
  if ( is_defined(SELF) && !is_nlist(SELF) ) {
    error('/software/components/gip2/ldif must be an nlist');
  };

  if ( FULL_HOSTNAME == GIP_CLUSTER_PUBLISHER_HOST ) {    
    # Build service endpoint and associated foreign key for each queue based on CE type
    queue_endpoints = list();
    foreign_keys = list("GlueSiteUniqueID="+SITE_NAME);
    foreach (queue;vos;CE_QUEUES['vos']) {
      if (exists(CE_QUEUES['lrms'][queue])) {
        jobmanager=CE_QUEUES['lrms'][queue];
        lrms = CE_BATCH_SYS_LIST[jobmanager];
      }
      else {
        jobmanager=CE_JM_TYPE;
        lrms = jobmanager;
      };
      foreach (i;ce;CE_HOSTS) {
        if ( index(ce,CE_HOSTS_CREAM) >= 0 ) {
          ce_flavor = 'cream';
        } else {
          ce_flavor = 'lcg';
        };
        
        if ( ce_flavor == 'cream' ) {
          # CREAM CE doesn't know about all LCG CE job manager variants...
          jobmanager = lrms;
          queue_endpoints[length(queue_endpoints)] = ce+":"+to_string(CE_PORT[ce_flavor])+"/cream-"+jobmanager+"-"+queue;
          foreign_keys[length(foreign_keys)] = "GlueCEUniqueID="+ce+":"+to_string(CE_PORT[ce_flavor])+"/cream-"+jobmanager+"-"+queue;
        } else {
          queue_endpoints[length(queue_endpoints)] = ce+":"+to_string(CE_PORT[ce_flavor])+"/jobmanager-"+jobmanager+"-"+queue;
          foreign_keys[length(foreign_keys)] = "GlueCEUniqueID="+ce+":"+to_string(CE_PORT[ce_flavor])+"/jobmanager-"+jobmanager+"-"+queue;
        };
      };
    };
  
    entries = nlist();
    entries[escape('dn: GlueClusterUniqueID='+GIP_CLUSTER_PUBLISHER_HOST+',Mds-Vo-name=resource,o=grid')] = 
      nlist(
            "objectClass",               list('GlueClusterTop','GlueCluster','GlueInformationService','GlueKey','GlueSchemaVersion'),
            "GlueClusterName",           list(GIP_CLUSTER_PUBLISHER_HOST),
            "GlueForeignKey",            foreign_keys,
            "GlueClusterService",        queue_endpoints,
            "GlueInformationServiceURL", list(RESOURCE_INFORMATION_URL),
            "GlueSchemaVersionMajor"   , list("1"),
            "GlueSchemaVersionMinor"   , list("3"),
           );
  
    # For GlueHostArchitecturePlatformType, assume the same type as CE until we support several subclusters
    # per cluster.
    average_core_num = to_double(CE_CPU_CONFIG['cores']) / CE_CPU_CONFIG['cpus'];
    hepspec06 = 4 * to_double(CE_SI00) / 1000;
    entries[escape('dn: GlueSubClusterUniqueID='+GIP_CLUSTER_PUBLISHER_HOST+', GlueClusterUniqueID='+GIP_CLUSTER_PUBLISHER_HOST+',Mds-Vo-name=resource,o=grid')] = 
      nlist(
            'objectClass',                      list('GlueClusterTop','GlueSubCluster','GlueHostApplicationSoftware','GlueHostArchitecture',
                                                     'GlueHostBenchmark','GlueHostMainMemory','GlueHostOperatingSystem','GlueHostProcessor',
                                                     'GlueInformationService','GlueKey','GlueSchemaVersion'),
            'GlueSubClusterUniqueID',           list(GIP_CLUSTER_PUBLISHER_HOST),
            'GlueChunkKey',                     list('GlueClusterUniqueID='+GIP_CLUSTER_PUBLISHER_HOST),
            'GlueHostArchitectureSMPSize',      list(CE_SMPSIZE),
            'GlueHostArchitecturePlatformType', list(CE_WN_ARCH),
            'GlueHostBenchmarkSF00',            list(CE_SF00),
            'GlueHostBenchmarkSI00',            list(CE_SI00),
            'GlueHostMainMemoryRAMSize',        list(CE_MINPHYSMEM),
            'GlueHostMainMemoryVirtualSize',    list(CE_MINVIRTMEM),
            'GlueHostNetworkAdapterInboundIP',  list(CE_INBOUNDIP),
            'GlueHostNetworkAdapterOutboundIP', list(CE_OUTBOUNDIP),
            'GlueHostOperatingSystemName',      list(CE_OS),
            'GlueHostOperatingSystemRelease',   list(CE_OS_RELEASE),
            'GlueHostOperatingSystemVersion',   list(CE_OS_VERSION),
            'GlueHostProcessorClockSpeed',      list(CE_CPU_SPEED),
            'GlueHostProcessorModel',           list(CE_CPU_MODEL),
            'GlueHostProcessorOtherDescription', list('Cores='+to_string(average_core_num)+
                                                      ',Benchmark='+to_string(hepspec06)+'-HEP-SPEC06'),
            'GlueHostProcessorVendor',          list(CE_CPU_VENDOR),
            'GlueSubClusterName',               list(FULL_HOSTNAME),
            'GlueSubClusterPhysicalCPUs',       list(to_string(CE_CPU_CONFIG['cpus'])),
            'GlueSubClusterLogicalCPUs',        list(to_string(CE_CPU_CONFIG['cores'])),
            'GlueSubClusterTmpDir',             list('/tmp'),
            'GlueSubClusterWNTmpDir',           list('/tmp'),
            "GlueInformationServiceURL", list(RESOURCE_INFORMATION_URL),
            'GlueHostApplicationSoftwareRunTimeEnvironment', CE_RUNTIMEENV,
            'GlueSchemaVersionMajor',           list("1"),
            'GlueSchemaVersionMinor',           list("3"),
            );
  
    hash = nlist();
    
    hash['template'] = GIP_GLUE_TEMPLATES_DIR + "/GlueCluster.template";
    hash['ldifFile'] = "static-file-Cluster.ldif";
    hash['entries'] = entries;
  
    SELF["lcg-info-static-cluster.conf"] = hash;
  };
  
  SELF;
};

#---------------------------------------------------------------
# Glue CE static information.
# When using GIP in cache mode and the current node is the LRMS
# server, a second LDIF file is produced with the entries for all
# CEs to be used as input by GIP plugin run in cache mode on the LRMS server.
# All CEs are assumed to share the same configuration for queue state, default SE...
# Cache mode is currently supported only for Torque/MAUI.
#---------------------------------------------------------------
"/software/components/gip2/ldif" = {
  # iterate over all defined queues (there is one GlueCE object per queue)
  if ( is_defined(CE_QUEUES['vos']) ) {
    # host_entries and all_ce_entries contain the VOView/CE DN list per LRMS
    host_entries = nlist();
    all_ce_entries = nlist();
    
    foreach (queue;vos;CE_QUEUES['vos']) {
      if (exists(CE_QUEUES['lrms'][queue])) {
        jobmanager=CE_QUEUES['lrms'][queue];
      }
      else {
        jobmanager=CE_BATCH_SYS;
      };
      lrms = CE_BATCH_SYS_LIST[jobmanager];
      if ( !is_nlist(host_entries[lrms]) ) {
        host_entries[lrms] = nlist();
      };
  
      if ( (lrms == 'pbs') && GIP_CE_USE_MAUI && GIP_CE_USE_CACHE && (FULL_HOSTNAME == LRMS_SERVER_HOST) ) {
        ce_list = CE_HOSTS;
        # Create only if necessary to avoid creating a useless emtpy file
        if ( !is_nlist(all_ce_entries[lrms]) ) {
          all_ce_entries[lrms] = nlist();
        };
      } else {
        ce_list = list(FULL_HOSTNAME);
      };
      
      foreach (i;ce;ce_list) {
        if ( index(ce,CE_HOSTS_CREAM) >= 0 ) {
          ce_flavor = 'cream';
          # On CREAM CE, there is no distinction between lcgpbs and pbs. Reset jobmanager to lrms.
          jobmanager = lrms;
          unique_id = ce+':'+to_string(CE_PORT[ce_flavor])+'/cream-'+jobmanager+'-'+queue;
        } else {
          ce_flavor = 'lcg';
          unique_id = ce+':'+to_string(CE_PORT[ce_flavor])+'/jobmanager-'+jobmanager+'-'+queue;
        };
        
        access = list();
        contact = list();
  
        # Try to set up initial GlueCEStateStatus according to defined
        # queue state, else assume default. Assume the same state on all CEs.
        # Will be updated by GIP to reflect the exact status.
        if ( exists('/software/components/pbsserver/queue/queuelist') ) {
          queuelist = value('/software/components/pbsserver/queue/queuelist');
          if ( is_defined(queuelist[queue]['attlist']['enabled']) &&
               is_defined(queuelist[queue]['attlist']['started']) ) {
            if ( queuelist[queue]['attlist']['enabled'] && queuelist[queue]['attlist']['started'] ) {
              queue_status = 'Production';
            } else if ( queuelist[queue]['attlist']['enabled'] && !queuelist[queue]['attlist']['started'] ) {
              queue_status = 'Queueing';
            } else if ( queuelist[queue]['attlist']['started'] && !queuelist[queue]['attlist']['enabled'] ) {
              queue_status = 'Draining';
            } else {
              queue_status = 'Closed';
            };
          } else {
            queue_status = CE_STATUS;
          };
        } else {
          queue_status = CE_STATUS;
        };
  
        entries = nlist();
        foreach (k;vo;vos) {
          vo_name = VO_INFO[vo]['name'];
          rule = "VO:"+ vo_name;
          access[length(access)] = rule;
  
          if ( is_defined(CE_DEFAULT_SE) ) {
            gluese_info_default_se = nlist('GlueCEInfoDefaultSE', list(CE_DEFAULT_SE));
          } else {
            gluese_info_default_se = nlist();
          };
          
          if ( is_defined(CE_VO_DEFAULT_SE[vo]) ) {
            gluese_info_default_se = nlist('GlueCEInfoDefaultSE', list(CE_VO_DEFAULT_SE[vo]));
          };
  
          if ( is_defined(VO_INFO[vo]['swarea']['name']) ) {
            sw_area = nlist('GlueCEInfoApplicationDir', list(VO_INFO[vo]['swarea']['name']));
          } else {
            sw_area = nlist();
          };
  
          #FIXME: use home directory if in a shared area
          shared_data_dir = nlist('GlueCEInfoDataDir', list(CE_DATADIR));
          
          entries[escape('dn: GlueVOViewLocalID='+vo_name+',GlueCEUniqueID='+unique_id+',Mds-Vo-name=resource,o=grid')] =
            merge(nlist(
                        'objecClass', list('GlueCETop','GlueVOView','GlueCEInfo','GlueCEState','GlueCEAccessControlBase','GlueCEPolicy',
                                           'GlueKey','GlueSchemaVersion'),
                        'GlueSchemaVersionMajor',           list('1'),
                        'GlueSchemaVersionMinor',           list('3'),
                        'GlueCEAccessControlBaseRule',      list(rule),
                        'GlueCEStateRunningJobs',           list('0'),
                        'GlueCEStateWaitingJobs',           list(to_string(GLUE_FAKE_JOB_VALUE)),
                        'GlueCEStateTotalJobs',             list('0'),
                        'GlueCEStateFreeJobSlots',          list('0'),
                        'GlueCEStateEstimatedResponseTime', list('2146660842'),
                        'GlueCEStateWorstResponseTime',     list('2146660842'),
                        'GlueChunkKey',                     list("GlueCEUniqueID="+unique_id),
                       ),
                  gluese_info_default_se,
                  sw_area,
                  shared_data_dir,
                 );
        };
    
        entries[escape('dn: GlueCEUniqueID='+unique_id+',Mds-Vo-name=resource,o=grid')] = 
          merge(nlist('objectClass',              list('GlueCETop','GlueCE','GlueCEAccessControlBase','GlueCEInfo','GlueCEPolicy', 'GlueCEState',
                                                       'GlueInformationService','GlueKey','GlueSchemaVersion'),
                      'GlueCEImplementationName',    list(GLUE_CE_IMPLEMENTATION[ce_flavor]),
                      'GlueCEImplementationVersion', list(CREAM_CE_VERSION),
                      'GlueCEHostingCluster',        list(GIP_CLUSTER_PUBLISHER_HOST),
                      'GlueCEName',                  list(queue),
                      'GlueCEUniqueID',              list(unique_id),
                      'GlueCEInfoGatekeeperPort',    list(to_string(CE_PORT[ce_flavor])),
                      'GlueCEInfoHostName',          list(FULL_HOSTNAME),
                      'GlueCEInfoLRMSType',          list(lrms),
                      'GlueCEInfoLRMSVersion',       list('not defined'),
                      'GlueCEInfoTotalCPUs',         list('0'),
                      'GlueCEInfoJobManager',        list(jobmanager),
                      'GlueCEInfoContactString',     list(unique_id),
                      'GlueCEInfoApplicationDir',         list("/home/"),
                      'GlueCEInfoDataDir',                list(CE_DATADIR),
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
                      'GlueForeignKey', list('GlueClusterUniqueID='+GIP_CLUSTER_PUBLISHER_HOST),
                      'GlueInformationServiceURL', list(RESOURCE_INFORMATION_URL),
                      'GlueCEAccessControlBaseRule', access,
                      'GlueCEPolicyMaxObtainableCPUTime', list('0'),
                      'GlueCEPolicyMaxObtainableWallClockTime', list('0'),
                      'GlueCEPolicyMaxSlotsPerJob', list('0'),
                      'GlueCEPolicyPreemption', list('0'),
                      'GlueCEPolicyMaxWaitingJobs', list('0'),
                      'GlueSchemaVersionMajor',     list('1'),
                      'GlueSchemaVersionMinor',     list('3'),
                     ),
                gluese_info_default_se
               );

        # Entries are for the current host, add them to the list of DN for the GIP standard LDIF file
        if ( ce == FULL_HOSTNAME ) {
          host_entries[lrms] = merge(host_entries[lrms],entries);
        };
        
        # Also add to LDIF file used when cache mode is enabled (several entries in ce_list)
        if ( is_nlist(all_ce_entries[lrms]) ) {
          all_ce_entries[lrms] = merge(all_ce_entries[lrms],entries);
        };
               
      };           # end of iteration over CEs
      
    };             # end of iteration over queues
                 
    # Create all needed LDIF files
    foreach (lrms;entries;host_entries) {
      conf_file = "lcg-info-static-ce-"+lrms+".conf";
      SELF[conf_file] = nlist();
      SELF[conf_file]['template'] = GIP_GLUE_TEMPLATES_DIR + "/GlueCE.template";
      SELF[conf_file]['ldifFile'] = "static-file-CE-"+lrms+".ldif";
      SELF[conf_file]['entries'] = entries;
    };
    foreach (lrms;entries;all_ce_entries) {
      conf_file = "lcg-info-static-all-ce-"+lrms+".conf";
      SELF[conf_file] = nlist();
      SELF[conf_file]['template'] = GIP_GLUE_TEMPLATES_DIR + "/GlueCE.template";
      SELF[conf_file]['ldifFile'] = GIP_VAR_DIR+"/static-file-all-CE-"+lrms+".ldif";
      SELF[conf_file]['entries'] = entries;
    };

  };
      
  SELF;
};


#---------------------------------------------------------------
# Glue CE-SE binding static information.
# Do not create if CE_FLAVOR is undefined (not a CE).
#---------------------------------------------------------------

"/software/components/gip2/ldif" = {
  if ( is_defined(CE_FLAVOR) ) {
    # iterate over all defined queues (there is one GlueCE object per queue)
    if ( is_defined(CE_QUEUES['vos']) ) {
      entries = nlist();
      
      foreach (queue;vos;CE_QUEUES['vos']) {
        if (exists(CE_QUEUES['lrms'][queue])) {
          jobmanager=CE_QUEUES['lrms'][queue];
        }
        else {
          jobmanager=CE_BATCH_SYS;
        };
        lrms = CE_BATCH_SYS_LIST[jobmanager];
    
        if ( CE_FLAVOR == 'cream' ) {
          # On CREAM CE, there is no distinction between lcgpbs and pbs. Reset jobmanager to lrms.
          jobmanager = lrms;
          unique_id = FULL_HOSTNAME+':'+to_string(CE_PORT[CE_FLAVOR])+'/cream-'+jobmanager+'-'+queue;
        } else {
          unique_id = FULL_HOSTNAME+':'+to_string(CE_PORT[CE_FLAVOR])+'/jobmanager-'+jobmanager+'-'+queue;
        };
          
        # Compute close SE list for the current queue by doing union of close SE
        # for all VO authorized to access the queue.
        # CE_VO_CLOSE_SE contains one entry per VO supported on the CE.
        se_nlist = nlist();
        foreach (i;vo;vos) {
          se_list = CE_VO_CLOSE_SE[vo];
          if ( is_defined(se_list) ) {
            foreach (i;v;se_list) {
              se_nlist[v] = 1;        # Value is useless
            };
          };
        };
        queue_close_se_list = list();
        if ( length(se_nlist) > 0 ) {
          foreach (se;v;se_nlist) {
            queue_close_se_list[length(queue_close_se_list)] = se;
          };
        };
    
        # Define list of SEs usable by this queue
        if ( length(queue_close_se_list) > 0 ) {
          entries[escape('dn: GlueCESEBindGroupCEUniqueID='+unique_id+',Mds-Vo-name=resource,o=grid')] = 
                         nlist('objectClass', list('GlueGeneralTop','GlueCESEBindGroup','GlueSchemaVersion'),
                               'GlueCESEBindGroupSEUniqueID', queue_close_se_list,
                               'GlueSchemaVersionMajor', list('1'),
                               'GlueSchemaVersionMinor', list('3'),
                              );
        };
    
        # Define a GlueCESEBindSEUniqueID per SE usable from the queue (close SE list).
        # Some SEs may not be managed locally and thus not be listed into SE_HOSTS.
        foreach (i;se;queue_close_se_list) {   
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
                error('Invalid SE host name ('+se+')');
              };
              accesspoint = '/dpm/'+toks[2]+'/home';
            } else if ( params['type'] == 'SE_classic' ) {
              accesspoint = SE_STORAGE_DIR;
            } else {
              error('No default value for SE Access Point for host '+se+' (type='+params['type']+')');
            };
          };
          
          entries[escape('dn: GlueCESEBindSEUniqueID='+se+',GlueCESEBindGroupCEUniqueID='+unique_id+',Mds-Vo-name=resource,o=grid')] =  
            nlist(
                 'objectClass', list('GlueGeneralTop','GlueCESEBind','GlueSchemaVersion'),
                 'GlueSchemaVersionMajor',      list('1'),
                 'GlueSchemaVersionMinor',      list('3'),
                 'GlueCESEBindGroupCEUniqueID', list(unique_id),
                 'GlueCESEBindCEAccesspoint',   list(accesspoint),
                 'GlueCESEBindCEUniqueID',      list(unique_id),
                 'GlueCESEBindMountInfo',       list(accesspoint),
                 'GlueCESEBindWeight',          list('0'),
                 );             
    
        };
      };
    };
    
    SELF["lcg-info-static-cesebind.conf"] = nlist();
    SELF["lcg-info-static-cesebind.conf"]['template'] = GIP_GLUE_TEMPLATES_DIR + "/GlueCESEBind.template";
    SELF["lcg-info-static-cesebind.conf"]['ldifFile'] = "static-file-CESEBind.ldif";
    SELF["lcg-info-static-cesebind.conf"]['entries'] = entries;
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
        foreach (i;service;service_list) {
            service_owner_cmd = '';
            service_acbr_cmd = '';
            foreach (i;vo;VOS_FULL) {
                service_owner_cmd = service_owner_cmd + ' echo ' + vo + ";";
                service_acbr_cmd = service_acbr_cmd + ' echo VO:' + vo + ";";
            };
            service_provider_conf = GIP_PROVIDER_SERVICE_CONF_BASE + '-' + service + '.conf';
            service_provider_wrapper = 'glite-info-service-' + service;
            service_uniqueid = FULL_HOSTNAME + '_' + GIP_CE_SERVICE_PARAMS[service]['type'];
            if ( is_defined(GIP_CE_SERVICE_PARAMS[service]['version']) ) {
                service_version_cmd = GIP_CE_SERVICE_PARAMS[service]['version'];
            } else if ( is_defined(GIP_CE_SERVICE_PARAMS[service]['version_rpm']) ) {
                service_version_cmd = "rpm -q --qf %{V} "+GIP_CE_SERVICE_PARAMS[service]['version_rpm'];
            } else {
                error("Either 'version' or 'version_rpm' must be present in GIP_CE_SERVICE_PARAMS["+service+"]");
            };
      
            SELF['confFiles'][escape(service_provider_conf)] = 
                "init = "+GIP_PROVIDER_SUBSERVICE[service]+" init\n" +
                "service_type = "+GIP_CE_SERVICE_PARAMS[service]['type']+"\n" +
                "get_version = "+service_version_cmd+"\n" +
                "get_endpoint = echo " + GIP_CE_SERVICE_PARAMS[service]['endpoint']+"\n" +
                "get_status = " + GIP_PROVIDER_SUBSERVICE['test'] + " " + GIP_CE_SERVICE_PARAMS[service]['service_status_name'] +
                    " && /sbin/service " + GIP_CE_SERVICE_PARAMS[service]['service'] + " status\n" +
                "WSDL_URL = " + GIP_CE_SERVICE_PARAMS[service]['wsdl'] + "\n" +
                "semantics_URL = " + GIP_CE_SERVICE_PARAMS[service]['semantics'] + "\n" +
                "get_starttime =  perl -e '@st=stat("+GIP_CE_SERVICE_PARAMS[service]['pid_file']+");print \"@st[10]\\n\";'\n" +
                "get_owner ="+service_owner_cmd+"\n" +
                "get_acbr ="+service_acbr_cmd+"\n" +
                "get_data =  echo -en " + GIP_CE_SERVICE_PARAMS[service]['service_data'] + "\n" +
                "get_implementationname = echo " + GIP_CE_SERVICE_PARAMS[service]['implementationname'] + "\n" +
                "get_implementationversion = "+service_version_cmd+"\n" +
                "get_services = echo\n";
            SELF['provider'][service_provider_wrapper] =
                "#!/bin/sh\n" + 
                GIP_PROVIDER_SERVICE + ' ' + service_provider_conf + ' ' + SITE_NAME + ' ' + service_uniqueid + "\n";

            # Glue v2
            SELF['provider'][service_provider_wrapper + '-glue2'] =
                "#!/bin/sh\n" + 
                GIP_PROVIDER_SERVICE + '-glue2 ' + service_provider_conf + ' ' + SITE_NAME + ' ' + service_uniqueid + "\n";
        };
    };
    SELF;
};

include { 'components/filecopy/config' };

'/software/components/filecopy/services/{/etc/glite/info/service/GlueCE.template}'= nlist(
  'config',file_contents('feature/gip/GlueCE.template'),
  'owner','root',
  'perms','0755',
);

'/software/components/filecopy/services/{/etc/glite/info/service/GlueCESEBind.template}'= nlist(
  'config',file_contents('feature/gip/GlueCESEBind.template'),
  'owner','root',
  'perms','0755',
);

'/software/components/filecopy/services/{/etc/glite/info/service/GlueCluster.template}'= nlist(
  'config',file_contents('feature/gip/GlueCluster.template'),
  'owner','root',
  'perms','0755',
);

'/software/components/filecopy/services/{/var/glite/static-file-CE-pbs-glue2.ldif}' = nlist(
  'config','',
  'owner', 'root',
  'perms', '0755',
);

'/software/components/filecopy/services/{/var/glite/static-file-all-CE-pbs-glue2.ldif}' = nlist(
  'config','',
  'owner', 'root',
  'perms', '0755',
);


include { 'components/symlink/config' };

'/software/components/symlink/links'=push(
  nlist(
    "name", "/opt/glite/var/info/"+LRMS_SERVER_HOST,
    "target", "/var/glite/info",
    "replace",  nlist("all","yes","link", "yes")
  )
);

include { 'components/dirperm/config' };

'/software/components/dirperm/paths' = push(
  nlist('owner','ldap:ldap',
        'path', '/var/lib/bdii/db/grid',
        'perm', '0755',
        'type','d'),
  nlist('owner','ldap:ldap',
        'path', '/var/lib/bdii/db/glue',
        'perm','0755',
        'type','d'),
  nlist('owner','ldap:ldap',
        'path','/var/lib/bdii/db/stats',
        'perm','0755',
        'type','d')
);

'/software/components/dirperm/paths' = append(nlist(
    'owner', 'root:root',
    'path', '/var/tmp/info-dynamic-scheduler-generic',
    'perm', '0755',
    'type', 'd',
));
