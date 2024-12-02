structure template features/htcondor/templ/global;

'text' = {

#Parameters validation

    if(!is_defined(CONDOR_CONFIG)){
        error('CONDOR_CONFIG must be defined.');
    };

    if(!is_defined(CONDOR_CONFIG['hosts'])){
        error('CONDOR_CONFIG[host] should be defined as the hostnames of the head machines of the cluster.');
    };


    txt =  <<EOF;
# File managed by quattor. Do Not edit.
# See features/htcondor/templ/cluster_conf in your quattor config.
EOF

    txt = txt + "UID_DOMAIN = " + CONDOR_CONFIG['domain'];

    txt = txt + <<EOF;

# Human readable name for your Condor pool
COLLECTOR_NAME = "Condor Cluster at $(UID_DOMAIN)"

EOF

    txt = txt + <<EOF;

CONDOR_ADMIN = root@$(FULL_HOSTNAME)
# The following should be the full name of the head node (Condor central manager)

EOF

    hosts = '';
    foreach(i; h; CONDOR_CONFIG['hosts']){
        hosts = hosts + " " + h;
    };

    txt = txt + "CONDOR_HOST =" + hosts;

    txt = txt + <<EOF;

REQUIRE_LOCAL_CONFIG_FILE = False

DAEMON_LIST = MASTER

EOF

    if(is_defined(CONDOR_CONFIG['shared_port'])){
        flag = 'FALSE';
        if(!CONDOR_CONFIG['shared_port']){
            flag = 'TRUE';
        };
        txt = txt + format("USE_SHARED_PORT = %s\n", flag);
    };
    if(is_defined(CONDOR_CONFIG['collector_port'])){
        txt = txt + format("COLLECTOR_PORT = %s\n", to_string(CONDOR_CONFIG['collector_port']));
    };

    if(is_defined(CONDOR_CONFIG['schedd_host'])){
        txt = txt + format("SCHEDD_HOST = %s\n", CONDOR_CONFIG['schedd_host']);
    };

    txt;
};
