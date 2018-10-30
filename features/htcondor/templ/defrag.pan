structure template features/htcondor/templ/defrag;

'text' = {

    config = dict(
        'DEFRAG_DRAINING_MACHINES_PER_HOUR', '30.0',
        'DEFRAG_MAX_CONCURRENT_DRAINING', '60',
        'DEFRAG_MAX_WHOLE_MACHINES', '300',
        'DEFRAG_INTERVAL', '600',
    );

    if(is_defined(CONDOR_CONFIG['defrag'])){
        foreach(par; val; config){
            if(is_defined(CONDOR_CONFIG['defrag'][par])){
                config[par] = CONDOR_CONFIG['defrag'][par];
            };
        };
    };
    txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) DEFRAG

EOF
    foreach(par; val; config){
        txt = txt + par + " = " + val + "\n";
    };
    txt = txt + <<EOF;
DEFRAG_SCHEDULE = graceful

## Allow some defrag configuration to be settable
DEFRAG.SETTABLE_ATTRS_ADMINISTRATOR = DEFRAG_MAX_CONCURRENT_DRAINING,DEFRAG_DRAINING_MACHINES_PER_HOUR,DEFRAG_MAX_WHOLE_MACHINES
ENABLE_RUNTIME_CONFIG = TRUE

# If a machine have more than 8 CPUs free or if a machine is a 8 or less CPUs machine
# We put a negative value to be not desirable
# Else, we try to find the machine who is closest to be free
DEFRAG_RANK = ifThenElse(Cpus >= 8, -10, (TotalCpus - Cpus)/(8.0 - Cpus))

# Definition of a "whole" machine:
# - anything with 8 free cores
# - empty machines
# - must be configured to actually start new jobs (otherwise machines which are deliberately being drained will be included)
DEFRAG_WHOLE_MACHINE_EXPR = ((Cpus == TotalCpus) || ((Cpus >= 8)&&(DynamicSlot=!=true))) && (Offline=!=True)

# Decide which machines to drain
# - must be Partitionable
# - must be online
# - must have more than 8 cores
DEFRAG_REQUIREMENTS = PartitionableSlot && Offline=!=True && TotalCpus>8

## Logs
MAX_DEFRAG_LOG = 104857600
MAX_NUM_DEFRAG_LOG = 10
EOF
    txt;
};

