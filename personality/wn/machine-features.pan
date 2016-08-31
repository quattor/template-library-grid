unique template personality/wn/machine-features;

variable MACHINE_FEATURES_TEMPLATE ?= undef;
variable MACHINE_FEATURES_PATH ?= '/etc/machinefeatures';
variable MACHINE_FEATURES_LIST ?= list(
    'grace_secs',
    'hs06',
    'shutdowntime',
    'total_cpu',
);

# Machine features can be defined through a structure template
variable MACHINE_FEATURES ?= {
    this = dict();
    if (is_defined(MACHINE_FEATURES_TEMPLATE) && exists(MACHINE_FEATURES_TEMPLATE)) {
        this = create(MACHINE_FEATURES_TEMPLATE);
    };
    this;
};

# Machine features can also be defined by node with the following variables
variable MACHINE_FEATURES = {
    if (is_defined(NODE_GRACE_SECS)) {
        SELF['grace_secs'][escape(FULL_HOSTNAME)] = NODE_GRACE_SECS;
    };
    if (is_defined(NODE_HEP_SPEC06)) {
        SELF['hs06'][escape(FULL_HOSTNAME)] = NODE_HEP_SPEC06;
    };
    if (is_defined(NODE_SHUTDOWN_TIME)) {
        SELF['shutdowntime'][escape(FULL_HOSTNAME)] = NODE_SHUTDOWN_TIME;
    };
    if (is_defined(NODE_JOB_SLOTS)) {
        SELF['total_cpu'][escape(FULL_HOSTNAME)] = NODE_JOB_SLOTS;
    };
    if (is_defined(NODE_TOTAL_CPU)) {
        SELF['total_cpu'][escape(FULL_HOSTNAME)] = NODE_TOTAL_CPU;
    };
    SELF;
};

# Try to use hardware's HEP-SPEC06 benchmark (unless already defined)
variable MACHINE_FEATURES = {
    if (exists('/hardware/benchmarks/hepspec06') && ! is_defined(SELF['hs06'][escape(FULL_HOSTNAME)])) {
        SELF['hs06'][escape(FULL_HOSTNAME)] = value('/hardware/benchmarks/hepspec06');
    };
    SELF;
};

# Define MACHINEFEATURES environment variable
include 'components/profile/config';
'/software/components/profile/env/MACHINEFEATURES' ?= MACHINE_FEATURES_PATH;

# Create path
include 'components/dirperm/config';
'/software/components/dirperm/paths' = append(
    dict(
        'path', MACHINE_FEATURES_PATH,
        'owner', 'root:root',
        'perm', '0755',
        'type', 'd',
    ),
);

# Create files
include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    foreach(k; v; MACHINE_FEATURES_LIST) {
        if (is_defined(MACHINE_FEATURES[v])) {
            key = FULL_HOSTNAME;
            follow = true;
            while (follow) {
                if (is_defined(MACHINE_FEATURES[v][escape(key)])) {
                    key = to_string(MACHINE_FEATURES[v][escape(key)]);
                } else {
                    follow = false;
                };
            };
            if (key != FULL_HOSTNAME) {
                SELF[escape(MACHINE_FEATURES_PATH + '/' + v)] = dict(
                    'config', key + "\n",
                    'owner', 'root',
                    'group', 'root',
                    'perms', '0644',
                    'backup', false,
                );
            };
        };
    };
    SELF;
};
