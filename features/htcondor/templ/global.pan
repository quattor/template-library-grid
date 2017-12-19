structure template features/htcondor/templ/global;

'text' = {

    #Parameters validation

     if(!is_defined(CONDOR_CONFIG)){
	error('CONDOR_CONFIG must be defined.');
     };

     if(!is_defined(CONDOR_CONFIG['host'])){
	error('CONDOR_CONFIG[host] should be defined as the hostname of the head machine of the cluster.');
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

    txt = txt + "CONDOR_HOST = " + CONDOR_CONFIG['host'];

    txt = txt + <<EOF;

REQUIRE_LOCAL_CONFIG_FILE = False

DAEMON_LIST = MASTER

EOF

   txt;
};
