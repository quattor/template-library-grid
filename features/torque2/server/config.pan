# Torque server configuration

unique template features/torque2/server/config;

include { 'features/torque2/server/rpms/config' };

# Assume 1 CPU per machine by default
variable WN_CPUS_DEF ?= 1;
# Assume 2 jobs per CPU by default (normal job + 1 MAUI SR)
variable WN_CPU_SLOTS ?= 2;

# include configuration common to client and server
include { 'features/torque2/config' };

# Queues to configure but not to export on the CE
variable CE_LOCAL_QUEUES ?= undef;

variable CE_MANAGERS = {
  if (exists(TORQUE_SERVER_PRIV_HOST) && is_defined(TORQUE_SERVER_PRIV_HOST)) {
    return("root@"+TORQUE_SERVER_PRIV_HOST+",root@"+TORQUE_SERVER_HOST);
  } else {
    return("root@"+TORQUE_SERVER_HOST);
  };
};
variable CE_OPERATORS ?= CE_MANAGERS;

# Default server attributes.
# mail_domain = never is a special value to disable sending of email to users
# in case of Torque/MAUI errors or when a job is canceled. This doesn't make
# sense on a grid CE as the users will never read them.
variable TORQUE_SERVER_ATTRS_DEFAULT = nlist(
                                             "acl_host_enable", true,
                                             "acl_hosts", ACL_HOSTS_STRING,
                                             "default_node", "lcgpro",
                                             "default_queue", "undefined",
                                             "job_stat_rate", 300,
                                             "log_events", 255,
                                             "log_file_max_size", 200000,     # 200 MB
                                             "log_file_roll_depth", 10,       # Means 2 GB max per day
                                             "log_level", 0,
                                             "mail_from", "adm",
                                             "managers", '\"'+CE_MANAGERS+'\"',
                                             "mail_domain", 'never',
                                             "mom_job_sync", true,
                                             "node_check_rate", 600,
                                             "node_pack", false,
                                             "node_ping_rate", 300,
                                             "operators", '\"'+CE_OPERATORS+'\"',
                                             "poll_jobs", true,
                                             "query_other_jobs", true,
                                             "scheduler_iteration", 600,
                                             "scheduling", true,
                                             "server_name",TORQUE_SERVER_HOST,
                                             "tcp_timeout", 6,
                                            );

# variable allowing to customize default server attributes
variable TORQUE_SERVER_ATTRS ?= nlist();

# Use HW configuration to define number of processors
variable TORQUE_USE_HW_CONFIG ?= true;

#
# TO_BE_FIXED: hack to setup the correct pbs parameters and allow submission by the CREAMCE
#

'/software/components/pbsserver/dependencies/post'=push('filecopy');

variable PBS_AUTHORIZED_USERS_SCRIPT ?= {
  command="qmgr -c 'set server authorized_users =*@";
  command_add="qmgr -c 'set server authorized_users +=*@";
  tmp_cmd="";
  if ( is_defined(CE_HOSTS) && (length(CE_HOSTS)) > 0 ) {
    foreach(i;ce;CE_HOSTS) {
      if ( tmp_cmd == "" ) {
       tmp_cmd = command+ce+"'\n";
      } else {
        tmp_cmd = tmp_cmd+command_add+ce+"'\n";
      };
    };
  } else {
    tmp_cmd = tmp_cmd+command+CE_HOST+"'\n";
  };
  contents = "#!/bin/bash\n";
  contents = contents+tmp_cmd;
  contents;
#"#! /bin/bash\nqmgr -c 'set server authorized_users =*@"+CE_HOST+"'\n";
};
variable TORQUE_MYINIT_SCRIPT ?= TORQUE_CONFIG_DIR + '/myinit.sh';
"/software/components/filecopy/services" = {
         SELF[escape(TORQUE_MYINIT_SCRIPT)]=
        nlist("config",PBS_AUTHORIZED_USERS_SCRIPT,
              "perms", "0700",
              "owner", "root",
              "group","root",
              "restart",TORQUE_MYINIT_SCRIPT,
	      "forceRestart",true,
        );
         SELF;
       };





# ----------------------------------------------------------------------------
# iptables
# ----------------------------------------------------------------------------
include { 'components/iptables/config' };

# Inbound port(s).

"/software/components/iptables/filter/rules" = push(
  nlist("command", "-A",
        "chain", "input",
        "protocol", "udp",
        "dst_port", "15001:15004",
        "target", "accept"));

"/software/components/iptables/filter/rules" = push(
  nlist("command", "-A",
        "chain", "input",
        "protocol", "tcp",
        "dst_port", "15001:15004",
        "target", "accept"));


# ----------------------------------------------------------------------------
# chkconfig
# Be sure not to start MOM on CE, in case it was started during RPM installation
# or by mistake
# ----------------------------------------------------------------------------
include { 'components/chkconfig/config' };

prefix '/software/components/chkconfig/service';
'pbs_server/on'        = '';
'pbs_server/startstop' = true;

'pbs_mom/off'          = '';
'pbs_mom/startstop'    = true;


# ----------------------------------------------------------------------------
# cron
# ----------------------------------------------------------------------------
include { 'components/cron/config' };

"/software/components/cron/entries" =
  push(nlist(
    "name","server-logs",
    "user","root",
    "frequency", "33 3 * * *",
    "command", "find "+TORQUE_CONFIG_DIR+"/server_logs -mtime +7 -exec gzip -9 {} \\;"));


# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------
include { 'components/altlogrotate/config' };

"/software/components/altlogrotate/entries/server-logs" =
  nlist("pattern", "/var/log/server-logs.ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "weekly",
        "create", true,
        "ifempty", true,
        "rotate", 1);


# ----------------------------------------------------------------------------
# pbsserver
# ----------------------------------------------------------------------------
include { 'components/pbsserver/config' };

"/software/components/pbsserver/pbsroot" = TORQUE_CONFIG_DIR;

"/software/components/pbsserver/env/PATH" = "/bin:/usr/bin";
"/software/components/pbsserver/env/LANG" = "C";

# To enable torque to keep track of completed jobs, uncomment this line.
"/software/components/pbsserver/env/TORQUEKEEPCOMPLETED" = "TRUE";


# Setup the server attributes.
"/software/components/pbsserver/server" = {
  SELF['manualconfig'] =  false;

  if ( !exists(SELF['attlist']) || !is_defined(SELF['attlist']) ) {
    SELF['attlist'] = nlist();
  };
  foreach (attr;val;TORQUE_SERVER_ATTRS_DEFAULT) {
    SELF['attlist'][attr] = val;
  };
  # If site-defined value for an attribute is undef, remove it if defined by default
  foreach (attr;val;TORQUE_SERVER_ATTRS) {
    if ( is_defined(val) ) {
      SELF['attlist'][attr] = val;
    } else {
      SELF['attlist'][attr] = null;
    };
  };

  SELF;
};





#
# Build queue names
#
include { 'features/torque2/server/build-queue-list' };


#
# These queue defaults will be used unless specific
# attributes are defined in the CE_QUEUES variable.
# Default values for queue attributes are overriden on
# a per attribute basis (not per queue).
#
variable CE_QUEUE_DEFAULTS ?= nlist(
  "queue_type", "Execution",
  "resources_max.pcput", "24:00:00",
  "resources_max.walltime", "36:00:00",
  "resources_default.walltime", "36:00:00",
);


# Default value for queue 'enabled' and 'started' attributes.
# If these attributes are also defined in CE_QUEUE_DEFAULTS, they are
# overridden.
# Default value is based on variable CE_STATUS to support draining or closing
# the CE. CE_STATUS valid values are :
#   - 'Production' : enabled=true, started=true (Defaults)
#   - 'Queuing' (job accepted but not executded) : enabled=true, started=false
#   - 'Draining' (no new job accepted) : enabled=false, started=true
#   - 'Closed' : enabled=false, started=false
variable CE_QUEUE_STATE_DEFAULTS ?= {
  state_defaults = nlist();
  if ( !exists(CE_STATUS) || !is_defined(CE_STATUS) || (CE_STATUS == 'Production') ) {
    state_defaults["enabled"] = true;
    state_defaults["started"] = true;
  } else if ( CE_STATUS == 'Queuing' ) {
    state_defaults["enabled"] = true;
    state_defaults["started"] = false;
  } else if ( CE_STATUS == 'Draining' ) {
    state_defaults["enabled"] = false;
    state_defaults["started"] = true;
  } else if ( CE_STATUS == 'Closed' ) {
    state_defaults["enabled"] = false;
    state_defaults["started"] = false;
  } else {
    error("Invalid CE_STATUS value ("+CE_STATUS+")");
  };
  state_defaults;
};



# Setup the queues.
"/software/components/pbsserver/queue" = {

  queuelist = nlist();

  keep_running_state = nlist();
  keep_running_list = CE_KEEP_RUNNING_QUEUES;
  foreach(i;queue;keep_running_list) {
    keep_running_state[queue] = nlist('enabled', true,
                                      'started', true,
                                     );
  };

  if ( length(CE_LOCAL_QUEUES) > 0 ) {
    qnames = merge(CE_QUEUES['vos'], CE_LOCAL_QUEUES['names']);
    atts = merge(CE_QUEUES['attlist'], CE_LOCAL_QUEUES['attlist']);
  } else {
    qnames = CE_QUEUES['vos'];
    atts = CE_QUEUES['attlist'];
  };
  atts_defaults = CE_QUEUE_DEFAULTS;
  foreach(k;v;qnames) {
    if (exists(CE_QUEUES['lrms'][k]) ) {
      mylrms=CE_QUEUES['lrms'][k];
    }
    else {
      mylrms=CE_BATCH_SYS;
    };
    if (mylrms=='pbs' || mylrms == 'lcgpbs' || mylrms=='torque') {
      queuelist[k] = nlist();
      queuelist[k]['manualconfig'] = false;
      if ( exists(keep_running_state[k]) ) {
        queuelist[k]['attlist'] = keep_running_state[k];
      } else {
        queuelist[k]['attlist'] = CE_QUEUE_STATE_DEFAULTS;
      };
      # Apply defaults
      if (exists(atts_defaults) && is_defined(atts_defaults)) {
        ok_atts = first(atts_defaults, att_name, att_value);
        while (ok_atts) {
          queuelist[k]['attlist'][att_name] = att_value;
          ok_atts = next(atts_defaults, att_name, att_value);
        };
      };
      # If specific attributes have been specified for the
      # current queue, add/replace them to the default attribute values
      if (exists(atts[k]) && is_defined(atts[k])) {
        ok_atts = first(atts[k], att_name, att_value);
        while (ok_atts) {
          queuelist[k]['attlist'][att_name] = att_value;
          ok_atts = next(atts[k], att_name, att_value);
        };
      queuelist[k]['attlist']['resources_default.walltime'] = queuelist[k]['attlist']['resources_max.walltime'];
      };
    };
  };

  SELF["manualconfig"] = false;
  SELF["queuelist"] = queuelist;
  SELF;
};


# Setup the nodes.
# Specific attributes can be set on specific nodes using WN_ATTRS
# variable. This variable is a nlist with one entry per node plus a default
# entry (key DEFAULT). DEFAULT entry if present is always applied before
# node specific entry. Each entry must be a nlist.
"/software/components/pbsserver/node" = nlist("manualconfig", false);
"/software/components/pbsserver/node/nodelist" = {
  nodes = nlist();
  if ( exists(WN_ATTRS) && is_defined(WN_ATTRS) && is_nlist(WN_ATTRS) ) {
    wn_attrs = WN_ATTRS;
  };
  foreach (i;wn;WORKER_NODES) {
    if ( TORQUE_USE_HW_CONFIG && exists(WN_CPU_CONFIG[wn]['slots']) && is_defined(WN_CPU_CONFIG[wn]['slots']) ) {
      process_slots = to_long(WN_CPU_CONFIG[wn]['slots']);
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
        process_slots = to_long(process_slots + extra_slots);
      } else {
        process_slots = to_long(process_slots * extra_slots);
      };
    } else {
      process_slots = to_long(process_slots * WN_CPU_SLOTS);
    };
    nodes[wn]["manualconfig"] = false;
    nodes[wn]["attlist"] = nlist(
        "np", process_slots,
        "properties", "lcgpro"
    );
    # Add other attributes defined in either DEFAULT or node specific entry
    att_entries = list("DEFAULT",wn);
    ok_entries = first(att_entries, e_k, e_v);
    while (ok_entries) {
      if ( exists(wn_attrs[e_v]) && is_defined(wn_attrs[e_v]) ) {
        if ( is_nlist(wn_attrs[e_v]) ) {
          ok_atts = first(wn_attrs[e_v], att_name, att_value);
          while(ok_atts) {
            nodes[wn]["attlist"][att_name] = att_value;
            ok_atts = next(wn_attrs[e_v], att_name, att_value);
          };
        } else {
          error("WN_ATTR_DEFAULTS entry '"+e_v+" value must be a nlist");
        };
      };
      ok_entries = next(att_entries, e_k, e_v);
    };
  };
  nodes;
};

variable TORQUE_SUBMIT_FILTER_DEFAULT ?= <<EOF;
#!/usr/bin/perl

# This script read a submission script on the standard input, modifies
# it, and writes the modified script on standard output.  This script
# makes two modifications:
#
#   * correct the node specification to allow all cpus to be used
#   * adds a NOQUEUE flag if the job came in on the sdj queue
#

my $GLOBUS_LOCATION = '/opt/globus';

while (<STDIN>) {

    # By default just copy the line.
    $line = $_;

    # If there is a nodes line, then extract the value and adjust it
    # as necessary.  Only modify the simple nodes request.  If there
    # is a more complicated request assume that the user knows what
    # he/she is doing and leave it alone.
    if (m/#PBS\s+-l\s+nodes=(\d+)\s*$/) {
        $line = process_nodes($1);

        # If the line wasn't empty, then multiple CPUs have been
        # requested.  Mark this as an MPI job.
        if ($line ne '') {
          $line .= "\n#PBS -A mpi\n";
        }
    }

    # If there is a queue option, check to see if it is "sdj".
    # If so, then add the option to not allow such jobs to be
    # queued.
    if (m/#PBS\s+-q\s+sdj/) {
        $line .= "#PBS -W x=\"FLAGS:NOQUEUE\"\n";
    }


    # If there is an existing accounts line, delete it.  The account
    # should not be set to the DN, because an internal maui table is
    # filled which prevents standing reservations from being defined.
    if (m/#PBS\s+-A/) {
        $line = '';
    }

    print $line;
}

# This takes the number specified in the "nodes" specification and
# returns a "PBS -l" line which can be allocated on the available
# resources.  This essentially does per-cpu allocation.
sub process_nodes {
    my $nodes = shift;
    my $line = "";

    # If the requested number of nodes is 1, just return an empty string.
    if ($nodes == 1) {
      return "";
    }

    # Collect information from the pbsnodes command on the number of
    # machine and cpus available.  Don't do anything with offline
    # nodes.
    open PBS, "pbsnodes -a |";
    my $state = 1;
    my %machines;
    while (<PBS>) {
        if (m/^\s*state\s*=\s*(\w+)/) {
            $state = ($1 eq "offline") ? 0 : 1;
        } elsif (m/^\s*status\s*=\s*.*ncpus=(\d+),/) {
            my $ncpus = $1;
            if ($state) {
                if (defined($machines{$ncpus})) {
                    $machines{$ncpus} = $machines{$ncpus}+1;
                } else {
                    $machines{$ncpus} = 1;
                }
            }
        }
    }
    close PBS;

    # Count the total number of machines and cpus.
    my $tnodes = 0;
    my $tcpus = 0;
    my $maxcpu = 0;
    foreach my $ncpus (sort num_ascending keys %machines) {
        $tnodes += $machines{$ncpus};
        $tcpus += $machines{$ncpus}*$ncpus;
        $maxcpu = $ncpus if ($tcpus>=$nodes);
    }

    if ($maxcpu==0) {

        # There aren't enough cpus to handle the request.  Just pass
        # the request through and let the job fail.
        $line .= "#PBS -l nodes=$nodes\n";

    } else {

        $line .="#PBS -l ";

        # We've already identified the largest machine we'll have to
        # allocate.  Start by allocating one of those and iterate until
        # all are used.
        my %allocated;
        my $remaining_cpus = $nodes;
        my $remaining_nodes = $tnodes;
        foreach my $ncpus (sort num_descending keys %machines) {
            if ($ncpus<=$maxcpu && $remaining_cpus>0) {
                my $nmach = $machines{$ncpus};
                for (my $i=0;
                     ($i<$nmach) && ($remaining_cpus>$remaining_nodes);
                     $i++) {

                    $remaining_cpus -= $ncpus;
                    $remaining_nodes -= 1;

                    # May only have to use part of a node.  Check here
                    # for that case.
                    my $used = ($remaining_cpus>=0)
                        ? $ncpus
                        : $ncpus+$remaining_cpus;

                    # Increase the allocation.
                    if (defined($allocated{$used})) {
                        $allocated{$used} += 1;
                    } else {
                        $allocated{$used} = 1;
                    }
                }

                # If we can fill out the rest without restricting the
                # number of cpus on a node, do so.
                if ($remaining_cpus<=$remaining_nodes &&
                    $remaining_cpus>0) {

                    my $used = 1;
                    if (defined($allocated{$used})) {
                        $allocated{$used} += $remaining_cpus;
                    } else {
                        $allocated{$used} = $remaining_cpus;
                    }
                    $remaining_cpus = 0;
                }
            }
        }

        my $first = 1;
        foreach my $i (sort num_descending keys %allocated) {
            $line .= "+" unless $first;
            $line .= "nodes=" if $first;
            $line .= $allocated{$i};
            $line .= ":ppn=" . $i;
            $first = 0;
        }
        $line .= "\n";
    }

    return $line;
}


sub num_ascending { $a <=> $b; }


sub num_descending { $b <=> $a; }

EOF

"/software/components/pbsserver/submitfilter" = {
  submit_filter = undef;
  if ( exists(TORQUE_SUBMIT_FILTER) &&
       is_defined(TORQUE_SUBMIT_FILTER) &&
       is_nlist(TORQUE_SUBMIT_FILTER) ) {
    if ( exists(TORQUE_SUBMIT_FILTER[TORQUE_SERVER_HOST]) && is_defined(TORQUE_SUBMIT_FILTER[TORQUE_SERVER_HOST]) ) {
      submit_filter = TORQUE_SUBMIT_FILTER[TORQUE_SERVER_HOST];
    } else if ( exists(TORQUE_SUBMIT_FILTER['DEFAULT']) && is_defined(TORQUE_SUBMIT_FILTER['DEFAULT']) ) {
      submit_filter = TORQUE_SUBMIT_FILTER['DEFAULT'];
    };
  };
  if ( !is_defined(submit_filter) ) {
    submit_filter = TORQUE_SUBMIT_FILTER_DEFAULT;
  };
  return(submit_filter)
};


# ----------------------------------------------------------------------------
# Include the blparser (batch log parser used by CREAM CE) if the variable
# BLPARSER_HOST is defined and matching current node.
# ----------------------------------------------------------------------------
variable BLPARSER_INCLUDE = if ( is_defined(BLPARSER_HOST)  && (BLPARSER_HOST == FULL_HOSTNAME) ) {
                                debug('Configuring blparser');
                                'features/blparser/service';
                            } else {
                                null;
                            };
include { BLPARSER_INCLUDE };

# ----------------------------------------------------------------------------
# Configuring munge
# ----------------------------------------------------------------------------

include { 'features/torque2/munge/config' };

# ----------------------------------------------------------------------------
# Define a cron job to ensure that PBS server is running properly.
# Script created as part of server/client common config : PBS_MONITORING_SCRIPT
# defined to the name of the created script.
# ----------------------------------------------------------------------------
include { 'components/cron/config' };
include { 'components/altlogrotate/config' };

variable PBS_MONITORING_SCRIPT ?= undef;

"/software/components/cron/entries" = if ( is_defined(PBS_MONITORING_SCRIPT) ) {
                                        push(nlist("name","pbs-monitoring",
                                                   "user","root",
                                                   "frequency", "5,20,35,50 * * * *",
                                                   "command", PBS_MONITORING_SCRIPT));
                                      } else {
                                        SELF;
                                      };

"/software/components/altlogrotate/entries" = {
  if ( is_defined(PBS_MONITORING_SCRIPT) ) {
    SELF['pbs-monitoring'] = nlist("pattern", "/var/log/pbs-monitoring.ncm-cron.log",
                                   "compress", true,
                                   "missingok", true,
                                   "frequency", "monthly",
                                   "create", true,
                                   "ifempty", true,
                                   "rotate", 1);
  };
  SELF;
};

variable TORQUE_COMMAND_LINKS ?= false;
include { 'components/symlink/config' };
"/software/components/symlink/links" = if (TORQUE_COMMAND_LINKS) {
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qstat",
        "target", "/usr/bin/qstat-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qsub",
        "target", "/usr/bin/qsub-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qhold",
        "target", "/usr/bin/qhold-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qrls",
        "target", "/usr/bin/qrls-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qalter",
        "target", "/usr/bin/qalter-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qselect",
        "target", "/usr/bin/qselect-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF[length(SELF)] = nlist(
        "name", "/usr/bin/qdel",
        "target", "/usr/bin/qdel-torque",
        "replace", nlist("link","yes"),
        "exists", true,
    );
    SELF;
} else {
    SELF;
};
