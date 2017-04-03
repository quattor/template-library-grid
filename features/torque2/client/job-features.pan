unique template features/torque2/client/job-features;

# convert hh:mm:ss to seconds
function hhmmss_to_secs = {
    if (ARGC != 1) {
        error('only one argument expected');
    };
    if (! is_string(ARGV[0])) {
        error('first argument must be a string');
    };
    hhmmss = split(':', ARGV[0]);
    to_long(hhmmss[0]) * 3600 + to_long(hhmmss[1]) * 60 + to_long(hhmmss[2]);
};

# convert torque size to bytes
function torque_size_to_bytes = {
    if (ARGC != 1) {
        error('only one argument expected');
    };
    if (! is_string(ARGV[0])) {
        error('first argument must be a string');
    };
    if (match(ARGV[0], 'tb')) {
        size = split('tb', ARGV[0]);
        return(to_long(size[0]) * 1099511627776);
    };
    if (match(ARGV[0], 'gb')) {
        size = split('gb', ARGV[0]);
        return(to_long(size[0]) * 1073741824);
    };
    if (match(ARGV[0], 'mb')) {
        size = split('mb', ARGV[0]);
        return(to_long(size[0]) * 1048576);
    };
    if (match(ARGV[0], 'kb')) {
        size = split('kb', ARGV[0]);
        return(to_long(size[0]) * 1024);
    };
    if (match(ARGV[0], 'b')) {
        size = split('b', ARGV[0]);
        return(to_long(size[0]));
    };
    -1;
};

# Default values
variable MACHINE_FEATURES_PATH ?= '/etc/machinefeatures';
variable ALLOCATED_CPU_DEFAULT ?= 1;
variable SHUTDOWNTIME_JOB_DEFAULT ?= -1;
variable GRACE_SECS_JOB_DEFAULT ?= -1;
variable WALL_LIMIT_SECS_DEFAULT ?= {
    this = 129600;
    if (is_defined(CE_QUEUE_DEFAULTS['resources_default.walltime'])) {
        this = hhmmss_to_secs(CE_QUEUE_DEFAULTS['resources_default.walltime']);
    };
    if (is_defined(CE_QUEUE_DEFAULTS['resources_max.walltime'])) {
        this = hhmmss_to_secs(CE_QUEUE_DEFAULTS['resources_max.walltime']);
    };
    this;
};
variable CPU_LIMIT_SECS_DEFAULT ?= {
    this = 86400;
    if (is_defined(CE_QUEUE_DEFAULTS['resources_max.cput'])) {
        this = hhmmss_to_secs(CE_QUEUE_DEFAULTS['resources_max.cput']);
    };
    if (is_defined(CE_QUEUE_DEFAULTS['resources_max.pcput'])) {
        this = hhmmss_to_secs(CE_QUEUE_DEFAULTS['resources_max.pcput']);
    };
    this;
};
variable MAX_RSS_BYTES_DEFAULT ?= {
    this = 2147483648;
    if (is_defined(CE_MINPHYSMEM)) {
        to_long(CE_MINPHYSMEM) * 1048576;
    };
    if (is_defined(CE_QUEUE_DEFAULTS['resources_default.pvmem'])) {
        this = torque_size_to_bytes(CE_QUEUE_DEFAULTS['resources_default.pvmem']);
    };
    if (is_defined(CE_QUEUE_DEFAULTS['resources_default.vmem'])) {
        this = torque_size_to_bytes(CE_QUEUE_DEFAULTS['resources_default.vmem']);
    };
    if (is_defined(CE_QUEUE_DEFAULTS['resources_max.pvmem'])) {
        this = torque_size_to_bytes(CE_QUEUE_DEFAULTS['resources_max.pvmem']);
    };
    if (is_defined(CE_QUEUE_DEFAULTS['resources_max.vmem'])) {
        this = torque_size_to_bytes(CE_QUEUE_DEFAULTS['resources_max.vmem']);
    };
    this;
};
variable MAX_SWAP_BYTES_DEFAULT ?= MAX_RSS_BYTES_DEFAULT / 2;
variable SCRATCH_LIMIT_BYTES_DEFAULT ?= {
    this = 21474836480;
    if (is_defined(CE_QUEUE_DEFAULTS['resources_max.file'])) {
        this = torque_size_to_bytes(CE_QUEUE_DEFAULTS['resources_max.file']);
    };
    this;
};

# Job features can be defined through a structure template
variable JOB_FEATURES_TEMPLATE ?= undef;
variable JOB_FEATURES ?= {
    this = dict();
    if (is_defined(JOB_FEATURES_TEMPLATE) && exists(JOB_FEATURES_TEMPLATE)) {
        this = create(JOB_FEATURES_TEMPLATE);
    };
    this;
};

# Job features can also be defined by node with the following variables
variable JOB_FEATURES = {
    if (is_defined(NODE_ALLOCATED_CPU)) SELF['allocated_cpu'][escape(FULL_HOSTNAME)] = NODE_ALLOCATED_CPU;
    if (is_defined(NODE_SHUTDOWNTIME_JOB)) SELF['shutdowntime_job'][escape(FULL_HOSTNAME)] = NODE_SHUTDOWNTIME_JOB;
    if (is_defined(NODE_GRACE_SECS_JOB)) SELF['grace_secs_job'][escape(FULL_HOSTNAME)] = NODE_GRACE_SECS_JOB;
    if (is_defined(NODE_WALL_LIMIT_SECS)) SELF['wall_limit_secs'][escape(FULL_HOSTNAME)] = NODE_WALL_LIMIT_SECS;
    if (is_defined(NODE_CPU_LIMIT_SECS)) SELF['cpu_limit_secs'][escape(FULL_HOSTNAME)] = NODE_CPU_LIMIT_SECS;
    if (is_defined(NODE_MAX_RSS_BYTES)) SELF['max_rss_bytes'][escape(FULL_HOSTNAME)] = NODE_MAX_RSS_BYTES;
    if (is_defined(NODE_MAX_SWAP_BYTES)) SELF['max_swap_bytes'][escape(FULL_HOSTNAME)] = NODE_MAX_SWAP_BYTES;
    if (is_defined(NODE_SCRATCH_LIMIT_BYTES)) SELF['scratch_limit_bytes'][escape(FULL_HOSTNAME)] = NODE_SCRATCH_LIMIT_BYTES;
    SELF;
};

# Define JOBFEATURES environment variable
include 'components/profile/config';
'/software/components/profile/env/JOBFEATURES' ?= "${TMPDIR}/jobfeatures";

# Create user prologue file
include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    this = "#!/bin/bash\n";
    this = this + "declare -A ALLOCATED_CPU CPU_LIMIT_SECS GRACE_SECS_JOB MAX_RSS_BYTES MAX_SWAP_BYTES SCRATCH_LIMIT_BYTES SHUTDOWNTIME_JOB WALL_LIMIT_SECS\n";
    # queue attributes
    foreach(k; v; CE_QUEUES_SITE['attlist']) {
        # Start with the default values
        allocated_cpu = ALLOCATED_CPU_DEFAULT;
        shutdowntime_job = SHUTDOWNTIME_JOB_DEFAULT;
        grace_secs_job = GRACE_SECS_JOB_DEFAULT;
        wall_limit_secs = WALL_LIMIT_SECS_DEFAULT;
        cpu_limit_secs = CPU_LIMIT_SECS_DEFAULT;
        max_rss_bytes = MAX_RSS_BYTES_DEFAULT;
        max_swap_bytes = MAX_SWAP_BYTES_DEFAULT;
        scratch_limit_bytes = SCRATCH_LIMIT_BYTES_DEFAULT;
        # Use values defined for each queue in the torque configuration
        if (is_defined(v['resources_max.walltime'])) wall_limit_secs = hhmmss_to_secs(v['resources_max.walltime']);
        if (is_defined(v['resources_max.cput'])) cpu_limit_secs = hhmmss_to_secs(v['resources_max.cput']);
        if (is_defined(v['resources_max.pcput'])) cpu_limit_secs = hhmmss_to_secs(v['resources_max.pcput']);
        if (is_defined(v['resources_max.pvmem'])) max_rss_bytes = torque_size_to_bytes(v['resources_max.pvmem']);
        if (is_defined(v['resources_max.vmem'])) max_rss_bytes = torque_size_to_bytes(v['resources_max.vmem']);
        if (is_defined(v['resources_max.file'])) scratch_limit_bytes = torque_size_to_bytes(v['resources_max.file']);
        # Override with values defined for each queue
        if (is_defined(JOB_FEATURES['allocated_cpu'][k])) allocated_cpu = JOB_FEATURES['allocated_cpu'][k];
        if (is_defined(JOB_FEATURES['shutdowntime_job'][k])) shutdowntime_job = JOB_FEATURES['shutdowntime_job'][k];
        if (is_defined(JOB_FEATURES['grace_secs_job'][k])) grace_secs_job = JOB_FEATURES['grace_secs_job'][k];
        if (is_defined(JOB_FEATURES['wall_limit_secs'][k])) wall_limit_secs = JOB_FEATURES['wall_limit_secs'][k];
        if (is_defined(JOB_FEATURES['cpu_limit_secs'][k])) cpu_limit_secs = JOB_FEATURES['cpu_limit_secs'][k];
        if (is_defined(JOB_FEATURES['max_rss_bytes'][k])) max_rss_bytes = JOB_FEATURES['max_rss_bytes'][k];
        if (is_defined(JOB_FEATURES['max_swap_bytes'][k])) max_swap_bytes = JOB_FEATURES['max_swap_bytes'][k];
        if (is_defined(JOB_FEATURES['scratch_limit_bytes'][k])) scratch_limit_bytes = JOB_FEATURES['scratch_limit_bytes'][k];
        # Override with values defined for each node
        if (is_defined(JOB_FEATURES['allocated_cpu'][escape(FULL_HOSTNAME)])) allocated_cpu = JOB_FEATURES['allocated_cpu'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['shutdowntime_job'][escape(FULL_HOSTNAME)])) shutdowntime_job = JOB_FEATURES['shutdowntime_job'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['grace_secs_job'][escape(FULL_HOSTNAME)])) grace_secs_job = JOB_FEATURES['grace_secs_job'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['wall_limit_secs'][escape(FULL_HOSTNAME)])) wall_limit_secs = JOB_FEATURES['wall_limit_secs'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['cpu_limit_secs'][escape(FULL_HOSTNAME)])) cpu_limit_secs = JOB_FEATURES['cpu_limit_secs'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['max_rss_bytes'][escape(FULL_HOSTNAME)])) max_rss_bytes = JOB_FEATURES['max_rss_bytes'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['max_swap_bytes'][escape(FULL_HOSTNAME)])) max_swap_bytes = JOB_FEATURES['max_swap_bytes'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['scratch_limit_bytes'][escape(FULL_HOSTNAME)])) scratch_limit_bytes = JOB_FEATURES['scratch_limit_bytes'][escape(FULL_HOSTNAME)];
        # Only declare non default values
        if (allocated_cpu != ALLOCATED_CPU_DEFAULT) this = this + "ALLOCATED_CPU[" + k + "]=" + to_string(allocated_cpu) + "\n";
        if (shutdowntime_job != SHUTDOWNTIME_JOB_DEFAULT) this = this + "SHUTDOWNTIME_JOB[" + k + "]=" + to_string(shutdowntime_job) + "\n";
        if (grace_secs_job != GRACE_SECS_JOB_DEFAULT) this = this + "GRACE_SECS_JOB[" + k + "]=" + to_string(grace_secs_job) + "\n";
        if (wall_limit_secs != CPU_LIMIT_SECS_DEFAULT) this = this + "WALL_LIMIT_SECS[" + k + "]=" + to_string(wall_limit_secs) + "\n";
        if (cpu_limit_secs != CPU_LIMIT_SECS_DEFAULT) this = this + "CPU_LIMIT_SECS[" + k + "]=" + to_string(cpu_limit_secs) + "\n";
        if (max_rss_bytes != MAX_RSS_BYTES_DEFAULT) this = this + "MAX_RSS_BYTES[" + k + "]=" + to_string(max_rss_bytes) + "\n";
        if (max_swap_bytes != MAX_SWAP_BYTES_DEFAULT) this = this + "MAX_SWAP_BYTES[" + k + "]=" + to_string(max_swap_bytes) + "\n";
        if (scratch_limit_bytes != SCRATCH_LIMIT_BYTES_DEFAULT) this = this + "SCRATCH_LIMIT_BYTES[" + k + "]=" + to_string(scratch_limit_bytes) + "\n";
    };
    # Create job features files
    this = this + "PBS_JOBID=$1\n";
    this = this + "PBS_QUEUE=$6\n";
    this = this + "export JOBFEATURES=${TMPDIR}/jobfeatures\n";
    this = this + "mkdir -p ${JOBFEATURES} || exit 1\n";
    this = this + "date '+%s' > ${JOBFEATURES}/jobstart_secs\n";
    this = this + "echo \"${PBS_JOBID}\" > ${JOBFEATURES}/job_id\n";
    this = this + "if [[ \"${ALLOCATED_CPU[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${ALLOCATED_CPU[$PBS_QUEUE]}\" > ${JOBFEATURES}/allocated_cpu\nelse\n";
    this = this + "    echo '" + to_string(ALLOCATED_CPU_DEFAULT) + "' > ${JOBFEATURES}/allocated_cpu\nfi\n";
    this = this + "if [[ \"${SHUTDOWNTIME_JOB[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${SHUTDOWNTIME_JOB[$PBS_QUEUE]}\" > ${JOBFEATURES}/shutdowntime_job\nfi\n";
    this = this + "if [[ \"${GRACE_SECS_JOB[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${GRACE_SECS_JOB[$PBS_QUEUE]}\" > ${JOBFEATURES}/grace_secs_job\nfi\n";
    this = this + "if [[ \"${WALL_LIMIT_SECS[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${WALL_LIMIT_SECS[$PBS_QUEUE]}\" > ${JOBFEATURES}/wall_limit_secs\nelse\n";
    this = this + "    echo '" + to_string(WALL_LIMIT_SECS_DEFAULT) + "' > ${JOBFEATURES}/wall_limit_secs\nfi\n";
    this = this + "if [[ \"${CPU_LIMIT_SECS[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${CPU_LIMIT_SECS[$PBS_QUEUE]}\" > ${JOBFEATURES}/cpu_limit_secs\nelse\n";
    this = this + "    echo '" + to_string(CPU_LIMIT_SECS_DEFAULT) + "' > ${JOBFEATURES}/cpu_limit_secs\nfi\n";
    this = this + "if [[ \"${MAX_RSS_BYTES[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${MAX_RSS_BYTES[$PBS_QUEUE]}\" > ${JOBFEATURES}/max_rss_bytes\nelse\n";
    this = this + "    echo '" + to_string(MAX_RSS_BYTES_DEFAULT) + "' > ${JOBFEATURES}/max_rss_bytes\nfi\n";
    this = this + "if [[ \"${MAX_SWAP_BYTES[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${MAX_SWAP_BYTES[$PBS_QUEUE]}\" > ${JOBFEATURES}/max_swap_bytes\nelse\n";
    this = this + "    echo '" + to_string(MAX_SWAP_BYTES_DEFAULT) + "' > ${JOBFEATURES}/max_swap_bytes\nfi\n";
    this = this + "if [[ \"${SCRATCH_LIMIT_BYTES[$PBS_QUEUE]+exists}\" ]] ; then\n";
    this = this + "    echo \"${SCRATCH_LIMIT_BYTES[$PBS_QUEUE]}\" > ${JOBFEATURES}/scratch_limit_bytes\nelse\n";
    this = this + "    echo '" + to_string(SCRATCH_LIMIT_BYTES_DEFAULT) + "' > ${JOBFEATURES}/scratch_limit_bytes\nfi\n";
    this = this + 'if [[ -f ' + to_string(MACHINE_FEATURES_PATH) + '/hs06 && -f ' + to_string(MACHINE_FEATURES_PATH) + "/total_cpu ]] ; then\n";
    this = this + '    bc -l <<< "scale=2;$(cat '+ to_string(MACHINE_FEATURES_PATH) + '/hs06) * $(cat ${JOBFEATURES}/allocated_cpu) / $(cat ' + to_string(MACHINE_FEATURES_PATH) + "/total_cpu)\" > ${JOBFEATURES}/hs06_job\nfi\n";
    SELF[escape(TORQUE_CONFIG_DIR + '/mom_priv/prologue.user')] = dict(
        'config', this,
        'owner', 'root',
        'group', 'root',
        'perms', '0755',
        'backup', false,
    );
    SELF;
};

# Create user epilogue file
include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    this = "#!/bin/bash\n";
    this = this + "JOBFEATURES=${TMPDIR}/jobfeatures\n";
    this = this + "rm -rf ${JOBFEATURES}\n";
    SELF[escape(TORQUE_CONFIG_DIR + '/mom_priv/epilogue.user')] = dict(
        'config', this,
        'owner', 'root',
        'group', 'root',
        'perms', '0755',
        'backup', false,
    );
    SELF;
};
