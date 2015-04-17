structure template features/htcondor/templ/worker;

'text' = {
       txt = <<EOF;

DAEMON_LIST = $(DAEMON_LIST) STARTD

EOF
	foreach(i;opt;CONDOR_CONFIG['options']['worker']){
		txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n"; 
	};
	txt = txt + format("MULTICORE=%s\n",CONDOR_CONFIG["multicore"]);
	if (exists(WN_ATTRS[FULL_HOSTNAME]) &&
        exists(WN_ATTRS[FULL_HOSTNAME]['state']) &&
        WN_ATTRS[FULL_HOSTNAME]['state'] == 'offline') {
        txt = txt + format("DRAIN=true\n",);
    } else {
        txt = txt + format("DRAIN=false\n",);
    };
    txt = txt + <<EOF;

# Default Multicore configuration
if $(MULTICORE)
    NUM_SLOTS=1
    NUM_SLOTS_TYPE_1=1
    SLOT_TYPE_1=100%
    SLOT_TYPE_1_PARTITIONABLE=true
endif

# Default drain configuration
if $(DRAIN)
    START = (regexp(".*group_ops.*", AcctGroup))
endif
EOF
    txt;
};


