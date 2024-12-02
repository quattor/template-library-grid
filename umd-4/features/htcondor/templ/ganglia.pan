structure template features/htcondor/templ/ganglia;

'text' = {

    txt =  <<EOF;
# File managed by quattor. Do Not edit.
# See features/htcondor/templ/cluster_conf in your quattor config.
DAEMON_LIST = $(DAEMON_LIST) GANGLIAD

GANGLIA_SEND_DATA_FOR_ALL_HOSTS=True
EOF
    txt;
};
