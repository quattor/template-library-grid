structure template features/htcondor/templ/defrag;

'text' = {
       txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) DEFRAG

DEFRAG_INTERVAL = 600
DEFRAG_DRAINING_MACHINES_PER_HOUR = 30.0
DEFRAG_MAX_CONCURRENT_DRAINING = 60
DEFRAG_MAX_WHOLE_MACHINES = 300
DEFRAG_SCHEDULE = graceful

## Allow some defrag configuration to be settable
DEFRAG.SETTABLE_ATTRS_ADMINISTRATOR = DEFRAG_MAX_CONCURRENT_DRAINING,DEFRAG_DRAINING_MACHINES_PER_HOUR,DEFRAG_MAX_WHOLE_MACHINES
ENABLE_RUNTIME_CONFIG = TRUE

## Which machines are more desirable to drain
DEFRAG_RANK = ifThenElse(Cpus >= 8, -10, (TotalCpus - Cpus)/(8.0 - Cpus))

# Definition of a "whole" machine:
# - anything with 8 cores (since multicore jobs only need 8 cores, don't need to drain whole machines with > 8 cores)
# - must be configured to actually start new jobs (otherwise machines which are deliberately being drained will be included)
DEFRAG_WHOLE_MACHINE_EXPR = ((Cpus == TotalCpus) || (Cpus >= 8))

# Decide which machines to drain
# - must not be cloud machines
# - must be healthy
# - must be configured to actually start new jobs
DEFRAG_REQUIREMENTS = PartitionableSlot

## Logs
MAX_DEFRAG_LOG = 104857600
MAX_NUM_DEFRAG_LOG = 10
EOF
};


