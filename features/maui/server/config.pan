
# MAUI configuration

unique template feature/maui/server/config;

# Directory where MAUI configuration and related scripts are located.
variable MAUI_CONFIG_DIR ?= '/var/spool/maui';


# Variable defining default MAUI configuration
#
# Definition of scheduling interval. This is done with 2 parameters.
# JOBAGGREGATIONTIME defines the time to wait after receiving a job
# event from Torque before begining a scheduling cycle. This allows to
# wait for several job events in this interval that will be processed in
# 1 pass resulting in better MAUI efficiency and better scheduling
# decisions.
# RMPOLLINTERVAL is the interval between 2 MAUI initiated queries of 
# Torque for new jobs. This acts as a catch-all mechanism and should not
# be set to low if there is a large number of jobs in queue or burst
# submissions.
# If you have short queues or/and jobs it is, worth to set
# JOBAGGREGATIONTIME to a short interval (10 seconds) and
# RMPOLLINTERVAL not to high...
# But too short interval can lead to a situation where resource
# consumption is high with a large number of jobs in queue and MAUI is
# no longer responding.
#
# DEFERTIME : This is the time maui will wait before trying to reschedule a job which 
# couldn't initially be scheduled because of a lack of resources.
# Set to something short if short and short-deadline jobs are 
# supported on your site but not too short if you have many job slots
# (must be correlated to scheduling time and let the chance for the pb
# to be fixed in some ways, for example by pbs-monitoring running every
# 15 mn by default).
# DEFERCOUNT : number of attempts to schedule a deferred job (at
# DEFERTIME interval) before placing it in BatchHold state (requiring
# execution of command releasehold to release it).
# Default for DEFERCOUNT+DEFERTIME allows for retrying during 2 hour
# before putting the job in BatchHold.
variable MAUI_SERVER_CONFIG ?= nlist();
variable MAUI_SERVER_CONFIG_DEFAULT = nlist('ADMIN1', 'root',
                                            'ADMIN3', GIP_USER,
                                            'ADMIN_HOST', TORQUE_SERVER_HOST,
                                            'DEFERCOUNT', 12,
                                            'DEFERTIME', '00:10:00',
                                            'ENABLEMULTIREQJOBS', true,
                                            'ENFORCERESOURCELIMITS', 'ON',
                                            'JOBAGGREGATIONTIME', '00:00:10',
                                            'JOBPRIOACCRUALPOLICY', 'FULLPOLICY',
                                            'LOGFILE', '/var/log/maui.log',
                                            'LOGFILEMAXSIZE', 100000000,
                                            'LOGFILEROLLDEPTH', 10,
                                            'LOGLEVEL', 0,
                                            'NODEALLOCATIONPOLICY', 'MAXBALANCE',
                                            'NODEPOLLFREQUENCY', 5,
                                            'RMPOLLINTERVAL', '00:01:00',
                                            'SERVERHOST', TORQUE_SERVER_HOST,
                                            'SERVERPORT', 40559,
                                            'SERVERMODE', 'NORMAL',
                                           );
   

# Job priority parameters.
#
# Fair-share policy parameters.  The base scheduling policy for jobs 
# uses fair-share scheduling with a correction applied for jobs staying
# a long time in queue.  This doesn't preclude short and short-
# deadline jobs from executing immediately when reservations are 
# available.
variable MAUI_SERVER_POLICY ?= nlist();
variable MAUI_SERVER_POLICY_DEFAULT = nlist(
                                            'FSDECAY', 0.95,
                                            'FSDEPTH', 28,
                                            'FSINTERVAL', '24:00:00',
                                            # DEDICATEDPS% would be better but doesn't work - MJ (7/7/07)
                                            'FSPOLICY', 'DEDICATEDPS',
                                            # FS contribution is typically (O)10 with FSGROUPWEIGHT=10 if difference
                                            # from target is < 10
                                            'FSWEIGHT', 1,
                                            'FSGROUPWEIGHT', 20,
                                            # XFACTOR is  1+QUEUETIME/WCLIMIT. Typically < 3 for jobs spending less
                                            # than 3 days in queue (with a default WCLIMIT = 1.5 day).
                                            # XFACTORWEIGHT=10 contributes 30 if 3 days in queue. Be sure to have
                                            # fairshare contributing more for small differences with target
                                            'QUEUETIMEWEIGHT', 0,
                                            'XFACTORWEIGHT', 10,
                                           );
   
        
# MAUI resource manager configuration
variable MAUI_SERVER_RMCFG ?= nlist();
variable MAUI_SERVER_RMCFG_DEFAULT ?= nlist('base', 'TYPE=PBS',
                                           );

# Variable defining configuration parameters specific to site.
# Added a the end of the configuration file
variable MAUI_SERVER_CONFIG_SITE ?= undef;

# Define VO (group) specific characteristics.
# This is mainly used to define fairshare parameters.
# Key must be a group name or DEFAULT. Default entry is applied to group not explicitly defined.
variable MAUI_GROUP_PARAMS ?= nlist();

# Define user specific characteristics.
# This is mainly used to define fairshare parameters
# Key must be a user name.
variable MAUI_USER_PARAMS ?= nlist();

# Define class specific characteristics.
# This is mainly used to define fairshare parameters
# Key is a class name or DEFAULT. Default entry is applied to class not explicitly defined.
variable MAUI_CLASS_PARAMS ?= nlist();

# Define account specific characteristics.
# This is mainly used to define fairshare parameters
# Key must be an account name.
variable MAUI_ACCOUNT_PARAMS ?= nlist();

# Define node specific characteristics.
# Key must be a node name or 'DEFAULT'.
variable MAUI_NODE_PARAMS ?= nlist();

# MAUI standing reservation configuration.
# MAUI_STANDING_RESERVATION_CLASSES defines classes that may access the SR. This is a nlist : key
# is a WN name and value is the list of classes as a comma separated list. DEFAULT entry is used for
# when there is no entry matching WN name associated with the SR.
variable MAUI_STANDING_RESERVATION_ENABLED ?= true;
variable MAUI_STANDING_RESERVATION_CLASSES ?= {
  if ( !exists(SELF['DEFAULT']) || !is_defined(SELF['DEFAULT']) ) {
    SELF['DEFAULT'] = nlist('DEFAULT', 'dteam,ops');
  };
};

# Check Torque has already been configured
variable CE_QUEUES ?= error('List of queues undefined : Torque must be configured first');

# Use HW configuration to configure number of standing reservation
variable MAUI_USE_HW_CONFIG ?= if ( is_defined(TORQUE_USE_HW_CONFIG ) )
{
                                 TORQUE_USE_HW_CONFIG;
                               } else {
                                 true;
                               };

# Postpone configuration of MAUI monitoring without disabling it. When postpone
# MAUI_MONITORING_TEMPLATE must be included explicitly at some later stage.
# Default: false (done now except if disabled).
variable MAUI_MONITORING_POSTPONED ?= false;


# ---------------------------------------------------------------------------- 
# chkconfig
# ---------------------------------------------------------------------------- 
include { 'components/chkconfig/config' };

"/software/components/chkconfig/service/maui/on" = ""; 
"/software/components/chkconfig/service/maui/startstop" = true; 
"/software/components/chkconfig/service/pbs_sched/off" = ""; 
"/software/components/chkconfig/service/pbs_sched/startstop" = true; 


# ---------------------------------------------------------------------------- 
# accounts
# ---------------------------------------------------------------------------- 
#include { 'feature/maui/server/user' };


# ---------------------------------------------------------------------------- 
# iptables
# ---------------------------------------------------------------------------- 
#include { 'components/iptables/config' };

# Inbound port(s).

# Outbound port(s).


# ---------------------------------------------------------------------------- 
# etcservices
# ---------------------------------------------------------------------------- 
include { 'components/etcservices/config' };

"/software/components/etcservices/entries" = 
  push("maui 15004/tcp");


# ---------------------------------------------------------------------------- 
# cron
# ---------------------------------------------------------------------------- 
#include { 'components/cron/config' };


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
#include { 'components/altlogrotate/config' }; 


# ---------------------------------------------------------------------------- 
# Build MAUI configuration from MAUI_SERVER_xxx variables, with 
# MAUI_SERVER_CONFIG_SITE added at the end of configuration file.
# For backward compatibility, if MAUI_CONFIG already exists just use it.
# ---------------------------------------------------------------------------- 
include { 'components/maui/config' }; 

variable MAUI_CONFIG ?= {
  config = '';

  # Merge default parameters with site parameters
  server_config = MAUI_SERVER_CONFIG;
  foreach (param;val;MAUI_SERVER_CONFIG_DEFAULT) {
    if ( !exists(server_config[param]) ) {
      server_config[param] = val;
    };
  };
  server_policy = MAUI_SERVER_POLICY;
  foreach (param;val;MAUI_SERVER_POLICY_DEFAULT) {
    if ( !exists(server_policy[param]) ) {
      server_policy[param] = val;
    };
  };
  server_rmcfg = MAUI_SERVER_RMCFG;
  foreach (param;val;MAUI_SERVER_RMCFG_DEFAULT) {
    if ( !exists(server_rmcfg[param]) ) {
      server_rmcfg[param] = val;
    };
  };
  
  config = config + "\n#Server main parameters\n";
  foreach (param;val;server_config) {
    if ( is_string(val) ) {
      valstr = val;
    } else {
      valstr = to_string(val);
    };
    config = config + param + "\t\t" + valstr + "\n";
  };

  config = config + "\n# Resource manager parameters\n";
  foreach (param;val;server_rmcfg) {
    if ( is_string(val) ) {
      valstr = val;
    } else {
      valstr = to_string(val);
    };
    config = config + "RMCFG[" + param + "]\t\t" + valstr + "\n";
  };
   
  config = config + "\n# Job priority parameters\n";  
  foreach (param;val;server_policy) {
    if ( is_string(val) ) {
      valstr = val;
    } else {
      valstr = to_string(val);
    };
    config = config + param + "\t\t" + valstr + "\n";
  };
  config = config + "\n";

  config = config + "\n# Site specific parameters\n";  
  if ( is_defined(MAUI_SERVER_CONFIG_SITE) ) {
    config = config + MAUI_SERVER_CONFIG_SITE;
  };
  
  # maui_def_part allows to keep track that an explicit default partition
  # has been configured (instead of MAUI default 'DEFAULT')
  if ( exists(MAUI_WN_PART_DEF) && is_defined(MAUI_WN_PART_DEF) && (length(MAUI_WN_PART_DEF) > 0) ) {
    maui_def_part = MAUI_WN_PART_DEF;
  } else {
    maui_def_part = undef;
  };

  # Configure default partition used by MAUI. This is done by disabling all
  # partitions by default and adding explicitly the allowed partition for each
  # group (VO). This allows to control partition access on a per VO basis.

  if ( exists(MAUI_GROUP_PART["DEFAULT"]) && is_defined(MAUI_GROUP_PART["DEFAULT"]) ) {
    maui_def_part_list = MAUI_GROUP_PART["DEFAULT"];
  } else {
    if ( is_defined(maui_def_part) ) {
      maui_def_part_list = maui_def_part;
    } else {
      maui_def_part_list = "DEFAULT";
    };
  };

  # Group (vo) parameters.
  # Add default entry for each VO without an explicit one.
  # Be sure to define an entry for each VO for other defaults (eg.
  # authorized partition list) to be added.
  group_list_params = MAUI_GROUP_PARAMS;
  if ( !is_defined(group_list_params["DEFAULT"]) ) {
    group_list_params["DEFAULT"] = '';
  };
  foreach (i;vo;VOS) {
    if ( !is_defined(MAUI_GROUP_PARAMS[vo]) ) {
      group_list_params[vo] = group_list_params["DEFAULT"];
    };
  };

  if ( is_defined(maui_def_part_list) ) {
    config = config + "# Node partitions are used keep jobs confined to appropriate nodes.\n";
    config = config + "# By default, allow access to NO partitions.\n";
    config = config + "SYSCFG[base] PLIST=\n\n";
  };
  
  config = config + "\n# Define parameters and partitions for each VO (group).\n";
  group_part = '';
  foreach (group_name;group_params;group_list_params) {
    if ( is_defined(maui_def_part_list) ) {
      if ( exists(MAUI_GROUP_PART[group_name]) && is_defined(MAUI_GROUP_PART[group_name]) ) {
        group_part = "PLIST=" + MAUI_GROUP_PART[group_name];
      } else {
        group_part = "PLIST=" + maui_def_part_list;
      };
    };
    if ( (length(group_params) > 0) || (length(group_part) > 0) ) {
      config = config + "GROUPCFG[" + group_name + "] " + group_params + " " + group_part + "\n";
    };
  };
  config = config + "\n";

  config = config + "\n# Define user specific parameters.\n";
  foreach (user_name;user_params;MAUI_USER_PARAMS) {
    config = config + "USERCFG[" + user_name + "] " + user_params + "\n";
  };
  config = config + "\n";

  config = config + "\n# Define class specific parameters.\n";
  foreach (class_name;queue_params;CE_QUEUES['vos']) {
    if ( exists(MAUI_CLASS_PARAMS[class_name]) && exists(MAUI_CLASS_PARAMS[class_name]) ) {
      class_params = MAUI_CLASS_PARAMS[class_name];
    } else if ( exists(MAUI_CLASS_PARAMS['DEFAULT']) && exists(MAUI_CLASS_PARAMS['DEFAULT']) ) {
      class_params = MAUI_CLASS_PARAMS['DEFAULT'];
    } else {
      class_params = undef;
    };
    if ( is_defined(class_params) ) {
      config = config + "CLASSCFG[" + class_name + "] " + class_params + "\n";
    };
  };

  if ( length(CE_LOCAL_QUEUES) > 0 ) {
    config = config + "\n# Add local queues if they exist.\n";
    foreach (class_name;queue_params;CE_LOCAL_QUEUES['names']) {
      if ( exists(MAUI_CLASS_PARAMS[class_name]) && exists(MAUI_CLASS_PARAMS[class_name]) ) {
        class_params = MAUI_CLASS_PARAMS[class_name];
      } else if ( exists(MAUI_CLASS_PARAMS['DEFAULT']) && exists(MAUI_CLASS_PARAMS['DEFAULT']) ) {
        class_params = MAUI_CLASS_PARAMS['DEFAULT'];
      } else {
        class_params = undef;
      };
      if ( is_defined(class_params) ) {
        config = config + "CLASSCFG[" + class_name + "] " + class_params + "\n";
      };
    };
  };

  config = config + "\n# Define account specific parameters.\n";
  foreach (account_name;account_params;MAUI_ACCOUNT_PARAMS) {
    config = config + "ACCOUNTCFG[" + account_name + "] " + account_params + "\n";
  };

  config = config + "\n# Configure each WN partition, attributes and standing reservation\n\n";
  # Add default for node-specific characteristics
  if ( is_defined(MAUI_NODE_PARAMS['DEFAULT']) ) {
    node_config = '';
    foreach (param;value;MAUI_NODE_PARAMS['DEFAULT']) {
      if ( is_string(value) ) {
        node_config = node_config + " " + param + "='" + value + "'";
      } else {
        node_config = node_config + " " + param + "=" + to_string(value);
      };
    };
    if ( length(node_config) > 0 ) {
      config = config + "# Add default node attributes\n";
      config = config + "NODECFG[DEFAULT]" + node_config + "\n\n";
    };
  };
  
  foreach (k;wn;WORKER_NODES) {
    node_config = '';
    
    # Determine node partition
    if ( exists(MAUI_WN_PART[wn]) ) {
      wn_part = MAUI_WN_PART[wn];
    } else {
      wn_part = maui_def_part;
    };
    if ( is_defined(wn_part) ) {
      config = config + "# Add node "+ wn + " to partition 'general'\n";
      if ( exists(MAUI_WN_PART[wn]) ) {
        wn_part = MAUI_WN_PART[wn];
      } else {
        wn_part = maui_def_part;
      };
      node_config = node_config + " PARTITION=" + wn_part;
    };
    
    # Add other node-specific characteristics
    if ( is_defined(MAUI_NODE_PARAMS[wn]) ) {
      foreach (param;value;MAUI_NODE_PARAMS[wn]) {
        if ( is_string(value) ) {
          node_config = node_config + " " + param + "='" + value + "'";
        } else {
          node_config = node_config + " " + param + "=" + to_string(value);
        };
      };
    };

    # Append node configuration to MAUI configuration (node_config
    # starts with a space)
    if ( length(node_config) > 0 ) {
      config = config + "NODECFG[" + wn + "]" + node_config + "\n\n";
    };
    
    # Compute the number of slots dedicated to SR.
    if ( MAUI_USE_HW_CONFIG && exists(WN_CPU_CONFIG[wn]['cores']) && is_defined(WN_CPU_CONFIG[wn]['cores']) ) {
      process_slots = to_long(WN_CPU_CONFIG[wn]['cores']);
    } else if ( exists(WN_CPUS[wn]) && is_defined(WN_CPUS[wn]) ) {
      process_slots = to_long(WN_CPUS[wn]);
    } else {
      process_slots = to_long(WN_CPUS_DEF);
    };
    if ( is_nlist(WN_CPU_SLOTS) ) {
      if ( exists(WN_CPU_SLOTS[wn]['value']) && is_defined(WN_CPU_SLOTS[wn]['value']) ) {
        extra_slots = to_double(WN_CPU_SLOTS[wn]['value']);
      } else {
        extra_slots = to_double(WN_CPU_SLOTS['DEFAULT']['value']);
      };
      extra_slots_add = false;
      if ( exists(WN_CPU_SLOTS['DEFAULT']['ADD']) && is_boolean(WN_CPU_SLOTS['DEFAULT']['ADD']) ) {
        extra_slots_add = WN_CPU_SLOTS['DEFAULT']['ADD'];
      };
      if ( exists(WN_CPU_SLOTS[wn]['ADD']) && is_boolean(WN_CPU_SLOTS[wn]['ADD']) ) {
        extra_slots_add = WN_CPU_SLOTS[wn]['ADD'];
      };
      if ( extra_slots_add ) {
        process_slots = to_long(extra_slots);
      } else {
        process_slots = to_long(process_slots * (extra_slots - 1));
      };
    } else {
      process_slots = to_long(process_slots * (WN_CPU_SLOTS - 1));
    };

    if ( MAUI_STANDING_RESERVATION_ENABLED ) {
      if ( exists(MAUI_STANDING_RESERVATION_CLASSES[wn]) && is_defined(MAUI_STANDING_RESERVATION_CLASSES[wn]) ) { 
        sr_classlist = MAUI_STANDING_RESERVATION_CLASSES[wn];
      } else {
        sr_classlist = MAUI_STANDING_RESERVATION_CLASSES['DEFAULT'];
      };
      sr_name = "sdj_"+to_string(k);
      if ( process_slots > 0 ) {
        rname = "SRCFG["+sr_name+"]";
        config = config + "# Job reservation for node "+wn+" shared by classes: "+sr_classlist+"\n";
        config = config + rname+" HOSTLIST="+wn+"\n";
        config = config + rname+" PERIOD=INFINITY\n";
        config = config + rname+" ACCESS=DEDICATED\n";
        config = config + rname+" PRIORITY=10\n";
        config = config + rname+" TASKCOUNT=1\n";
        config = config + rname+" RESOURCES=PROCS:"+to_string(process_slots)+"\n";
        config = config + rname+" CLASSLIST="+sr_classlist+"\n\n";
      }
    } else {
      debug('MAUI SR '+sr_name+" on "+wn+" not configured (no proc available)");
    };
  };

  config;
};

"/software/components/maui/contents" ?= MAUI_CONFIG;


# ---------------------------------------------------------------------------- 
# Define a cron job to ensure that MAUI is running properly
# Define MAUI_MONITORING_TEMPLATE to null to suppress installation of this script.
# If MAUI_MONITORING_POSTPONED is true, don't configure it now. This flag is used
# when maui-monitoring configuration depends on other configuration parts like GIP config.
#-----------------------------------------------------------------------------
variable MAUI_MONITORING_TEMPLATE ?= if ( is_defined(MAUI_MONITORING_TEMPLATE) ||
                                          is_null(MAUI_MONITORING_TEMPLATE) ) {
                                      MAUI_MONITORING_TEMPLATE;
                                    } else {
                                      'feature/maui/server/maui-monitoring';
                                    };
include { if ( ! MAUI_MONITORING_POSTPONED ) MAUI_MONITORING_TEMPLATE };

# ----------------------------------------------------------------------------
# Add a script to get a worker node status summary
# ----------------------------------------------------------------------------

variable MAUI_NODE_STATUS_SCRIPT ?= MAUI_CONFIG_DIR + "/display_node_status";
variable CONTENTS = <<EOF;
#!/bin/ksh

nodes=$(mdiag -n | grep -v '^WARNING:' | egrep 'Drained|Running|Idle|Busy' | grep -v Total | awk '{print $1}')

for fullnode in $nodes
do
  echo -n "Checking node $fullnode ... "
  node=$(echo $fullnode | awk -F. '{print $1}')

  node_status=$(mdiag -n $fullnode | grep $fullnode | head -1 | awk '{print $2}')
  if [ "$node_status" != "Idle" ]
  then
    jobs=$(showq -r | grep $node | awk '{print $1}')
    job_count=$(echo $jobs | wc -w | awk '{print $1}')
  else
    job_count=0
  fi

  if [ $job_count -eq 0 ]
  then
    echo "$node_status (Free)"
  else
    echo "$node_status ($job_count jobs running)"
  fi
done
EOF

# Now actually add the file to the configuration.
'/software/components/filecopy/services' =
  npush(escape(MAUI_NODE_STATUS_SCRIPT),
        nlist('config',CONTENTS,
              'owner','root:root',
              'perms', '0755'));
