unique template features/torque2/client/job-features;

# Default values
variable CPUFACTOR_LRMS_DEFAULT ?= 1;
variable CPU_LIMIT_SECS_DEFAULT ?= 3600;
variable WALL_LIMIT_SECS_DEFAULT ?= 5400;
variable DISK_LIMIT_GB_DEFAULT ?= 20;
variable MEM_LIMIT_MB_DEFAULT ?= {
    if (is_defined(CE_MINPHYSMEM)) {
        to_long(CE_MINPHYSMEM) * 1000 / 1024;
    } else {
        2000;
    };
};
variable ALLOCATED_CPU_DEFAULT ?= 1;
variable SHUTDOWNTIME_JOB_DEFAULT ?= -1;
variable JOB_FEATURES_TEMPLATE ?= undef;

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

# convert torque size to GB
function torque_size_to_gb = {
    if (ARGC != 1) {
        error('only one argument expected');
    };
    if (! is_string(ARGV[0])) {
        error('first argument must be a string');
    };
    if (match(ARGV[0], 'tb')) {
        size = split('tb', ARGV[0]);
        return(to_long(size[0]) * 1000);
    };
    if (match(ARGV[0], 'gb')) {
        size = split('gb', ARGV[0]);
        return(to_long(size[0]));
    };
    if (match(ARGV[0], 'mb')) {
        size = split('mb', ARGV[0]);
        return(to_long(size[0]) / 1024);
    };
    if (match(ARGV[0], 'kb')) {
        size = split('kb', ARGV[0]);
        return(to_long(size[0]) / 1048576);
    };
    if (match(ARGV[0], 'b')) {
        size = split('b', ARGV[0]);
        return(to_long(size[0]) / 1073741824);
    };
    -1;
};

# Job features can be defined through a structure template
variable JOB_FEATURES ?= {
    this = dict();
    if (is_defined(JOB_FEATURES_TEMPLATE) && exists(JOB_FEATURES_TEMPLATE)) {
        this = create(JOB_FEATURES_TEMPLATE);
    };
    this;
};

# Job features can also be defined by node with the following variables
variable JOB_FEATURES = {
    if (is_defined(NODE_CPUFACTOR_LRMS)) SELF['cpufactor_lrms'][escape(FULL_HOSTNAME)] = NODE_CPUFACTOR_LRMS;
    if (is_defined(NODE_CPU_LIMIT_SECS)) SELF['cpu_limit_secs'][escape(FULL_HOSTNAME)] = NODE_CPU_LIMIT_SECS;
    if (is_defined(NODE_WALL_LIMIT_SECS)) SELF['wall_limit_secs'][escape(FULL_HOSTNAME)] = NODE_WALL_LIMIT_SECS;
    if (is_defined(NODE_DISK_LIMIT_GB)) SELF['disk_limit_GB'][escape(FULL_HOSTNAME)] = NODE_DISK_LIMIT_GB;
    if (is_defined(NODE_MEM_LIMIT_MB)) SELF['mem_limit_MB'][escape(FULL_HOSTNAME)] = NODE_MEM_LIMIT_MB;
    if (is_defined(NODE_ALLOCATED_CPU)) SELF['allocated_CPU'][escape(FULL_HOSTNAME)] = NODE_ALLOCATED_CPU;
    if (is_defined(NODE_SHUTDOWNTIME_JOB)) SELF['shutdowntime_job'][escape(FULL_HOSTNAME)] = NODE_SHUTDOWNTIME_JOB;
    SELF;
};

# Define JOBFEATURES environment variable
include 'components/profile/config';
'/software/components/profile/env/JOBFEATURES' ?= "${TMPDIR}/jobfeatures/${PBS_JOBID}";

# Create user prologue file
include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    this = "#!/bin/bash\n";
    this = this + "declare -A CPUFACTOR_LRMS CPU_LIMIT_SECS CPU_LIMIT_SECS_LRMS WALL_LIMIT_SECS WALL_LIMIT_SECS_LRMS DISK_LIMIT_GB MEM_LIMIT_MB ALLOCATED_CPU SHUTDOWNTIME_JOB\n";
    # queue attributes
    foreach(k; v; CE_QUEUES_SITE['attlist']) {
        # Start with the default values
        cpufactor_lrms = CPUFACTOR_LRMS_DEFAULT;
        cpu_limit_secs = CPU_LIMIT_SECS_DEFAULT;
        wall_limit_secs = WALL_LIMIT_SECS_DEFAULT;
        disk_limit_GB = DISK_LIMIT_GB_DEFAULT;
        mem_limit_MB = MEM_LIMIT_MB_DEFAULT;
        allocated_CPU = ALLOCATED_CPU_DEFAULT;
        shutdowntime_job = SHUTDOWNTIME_JOB_DEFAULT;
        # Use values defined for each queue in the torque configuration
        if (is_defined(v['resources_max.cput'])) cpu_limit_secs = hhmmss_to_secs(v['resources_max.cput']);
        if (is_defined(v['resources_max.pcput'])) cpu_limit_secs = hhmmss_to_secs(v['resources_max.pcput']);
        if (is_defined(v['resources_max.walltime'])) wall_limit_secs = hhmmss_to_secs(v['resources_max.walltime']);
        if (is_defined(v['resources_max.file'])) disk_limit_GB = torque_size_to_gb(v['resources_max.file']);
        if (is_defined(v['resources_max.pvmem'])) mem_limit_MB = torque_size_to_gb(v['resources_max.pvmem']);
        if (is_defined(v['resources_max.vmem'])) mem_limit_MB = torque_size_to_gb(v['resources_max.vmem']);
        # Override with values defined for each queue
        if (is_defined(JOB_FEATURES['cpufactor_lrms'][k])) cpufactor_lrms = JOB_FEATURES['cpufactor_lrms'][k];
        if (is_defined(JOB_FEATURES['cpu_limit_secs'][k])) cpu_limit_secs = JOB_FEATURES['cpu_limit_secs'][k];
        if (is_defined(JOB_FEATURES['wall_limit_secs'][k])) wall_limit_secs = JOB_FEATURES['wall_limit_secs'][k];
        if (is_defined(JOB_FEATURES['disk_limit_GB'][k])) disk_limit_GB = JOB_FEATURES['disk_limit_GB'][k];
        if (is_defined(JOB_FEATURES['mem_limit_MB'][k])) mem_limit_MB = JOB_FEATURES['mem_limit_MB'][k];
        if (is_defined(JOB_FEATURES['allocated_CPU'][k])) allocated_CPU = JOB_FEATURES['allocated_CPU'][k];
        if (is_defined(JOB_FEATURES['shutdowntime_job'][k])) shutdowntime_job = JOB_FEATURES['shutdowntime_job'][k];
        # Override with values defined for each node
        if (is_defined(JOB_FEATURES['cpufactor_lrms'][escape(FULL_HOSTNAME)])) cpufactor_lrms = JOB_FEATURES['cpufactor_lrms'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['cpu_limit_secs'][escape(FULL_HOSTNAME)])) cpu_limit_secs = JOB_FEATURES['cpu_limit_secs'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['wall_limit_secs'][escape(FULL_HOSTNAME)])) wall_limit_secs = JOB_FEATURES['wall_limit_secs'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['disk_limit_GB'][escape(FULL_HOSTNAME)])) disk_limit_GB = JOB_FEATURES['disk_limit_GB'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['mem_limit_MB'][escape(FULL_HOSTNAME)])) mem_limit_MB = JOB_FEATURES['mem_limit_MB'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['allocated_CPU'][escape(FULL_HOSTNAME)])) allocated_CPU = JOB_FEATURES['allocated_CPU'][escape(FULL_HOSTNAME)];
        if (is_defined(JOB_FEATURES['shutdowntime_job'][escape(FULL_HOSTNAME)])) shutdowntime_job = JOB_FEATURES['shutdowntime_job'][escape(FULL_HOSTNAME)];
        # Only declare non default values
        if (cpufactor_lrms != CPUFACTOR_LRMS_DEFAULT) this = this + "CPUFACTOR_LRMS[" + k + "]=" + to_string(cpufactor_lrms) + "\n";
        if (cpu_limit_secs != CPU_LIMIT_SECS_DEFAULT) this = this + "CPU_LIMIT_SECS[" + k + "]=" + to_string(cpu_limit_secs) + "\n";
        if (cpufactor_lrms != CPUFACTOR_LRMS_DEFAULT || cpu_limit_secs != CPU_LIMIT_SECS_DEFAULT) this = this + "CPU_LIMIT_SECS_LRMS[" + k + "]=" + to_string(cpu_limit_secs / cpufactor_lrms) + "\n";
        if (wall_limit_secs != CPU_LIMIT_SECS_DEFAULT) this = this + "WALL_LIMIT_SECS[" + k + "]=" + to_string(wall_limit_secs) + "\n";
        if (cpufactor_lrms != CPUFACTOR_LRMS_DEFAULT || wall_limit_secs != CPU_LIMIT_SECS_DEFAULT) this = this + "WALL_LIMIT_SECS_LRMS[" + k + "]=" + to_string(wall_limit_secs / cpufactor_lrms) + "\n";
        if (disk_limit_GB != DISK_LIMIT_GB_DEFAULT) this = this + "DISK_LIMIT_GB[" + k + "]=" + to_string(disk_limit_GB) + "\n";
        if (mem_limit_MB != MEM_LIMIT_MB_DEFAULT) this = this + "MEM_LIMIT_MB[" + k + "]=" + to_string(mem_limit_MB) + "\n";
        if (allocated_CPU != ALLOCATED_CPU_DEFAULT) this = this + "ALLOCATED_CPU[" + k + "]=" + to_string(allocated_CPU) + "\n";
        if (shutdowntime_job != SHUTDOWNTIME_JOB_DEFAULT) this = this + "SHUTDOWNTIME_JOB[" + k + "]=" + to_string(shutdowntime_job) + "\n";
    };
    # Create job features files
    this = this + "PBS_JOBID=$1\n";
    this = this + "PBS_QUEUE=$6\n";
    this = this + "export JOBFEATURES=${TMPDIR}/jobfeatures/${PBS_JOBID}\n";
    this = this + "mkdir -p ${JOBFEATURES} || exit 1\n";
    this = this + "date '+%s' > ${JOBFEATURES}/jobstart_secs\n";
    this = this + "if [ \"${CPUFACTOR_LRMS[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${CPUFACTOR_LRMS[$PBS_QUEUE]}\" > ${JOBFEATURES}/cpufactor_lrms\nelse\n";
    this = this + "    echo '" + to_string(CPUFACTOR_LRMS_DEFAULT) + "' > ${JOBFEATURES}/cpufactor_lrms\nfi\n";
    this = this + "if [ \"${CPU_LIMIT_SECS[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${CPU_LIMIT_SECS[$PBS_QUEUE]}\" > ${JOBFEATURES}/cpu_limit_secs\nelse\n";
    this = this + "    echo '" + to_string(CPU_LIMIT_SECS_DEFAULT) + "' > ${JOBFEATURES}/cpu_limit_secs\nfi\n";
    this = this + "if [ \"${CPU_LIMIT_SECS_LRMS[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${CPU_LIMIT_SECS_LRMS[$PBS_QUEUE]}\" > ${JOBFEATURES}/cpu_limit_secs_lrms\nelse\n";
    this = this + "    echo '" + to_string(CPU_LIMIT_SECS_DEFAULT / CPUFACTOR_LRMS_DEFAULT) + "' > ${JOBFEATURES}/cpu_limit_secs_lrms\nfi\n";
    this = this + "if [ \"${WALL_LIMIT_SECS[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${WALL_LIMIT_SECS[$PBS_QUEUE]}\" > ${JOBFEATURES}/wall_limit_secs\nelse\n";
    this = this + "    echo '" + to_string(WALL_LIMIT_SECS_DEFAULT) + "' > ${JOBFEATURES}/wall_limit_secs\nfi\n";
    this = this + "if [ \"${WALL_LIMIT_SECS_LRMS[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${WALL_LIMIT_SECS_LRMS[$PBS_QUEUE]}\" > ${JOBFEATURES}/wall_limit_secs_lrms\nelse\n";
    this = this + "    echo '" + to_string(WALL_LIMIT_SECS_DEFAULT / CPUFACTOR_LRMS_DEFAULT) + "' > ${JOBFEATURES}/wall_limit_secs_lrms\nfi\n";
    this = this + "if [ \"${DISK_LIMIT_GB[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${DISK_LIMIT_GB[$PBS_QUEUE]}\" > ${JOBFEATURES}/disk_limit_GB\nelse\n";
    this = this + "    echo '" + to_string(DISK_LIMIT_GB_DEFAULT) + "' > ${JOBFEATURES}/disk_limit_GB\nfi\n";
    this = this + "if [ \"${MEM_LIMIT_MB[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${MEM_LIMIT_MB[$PBS_QUEUE]}\" > ${JOBFEATURES}/mem_limit_MB\nelse\n";
    this = this + "    echo '" + to_string(MEM_LIMIT_MB_DEFAULT) + "' > ${JOBFEATURES}/mem_limit_MB\nfi\n";
    this = this + "if [ \"${ALLOCATED_CPU[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${ALLOCATED_CPU[$PBS_QUEUE]}\" > ${JOBFEATURES}/allocated_CPU\nelse\n";
    this = this + "    echo '" + to_string(ALLOCATED_CPU_DEFAULT) + "' > ${JOBFEATURES}/allocated_CPU\nfi\n";
    this = this + "if [ \"${SHUTDOWNTIME_JOB[$PBS_QUEUE]+exists}\" ]; then\n";
    this = this + "    echo \"${SHUTDOWNTIME_JOB[$PBS_QUEUE]}\" > ${JOBFEATURES}/shutdowntime_job\nfi\n";
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
    this = this + "PBS_JOBID=$1\n";
    this = this + "JOBFEATURES=${TMPDIR}/jobfeatures/${PBS_JOBID}\n";
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
