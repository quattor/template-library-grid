structure template features/htcondor/templ/had;

'text' = {

    if(!is_defined(CONDOR_CONFIG)){
        error('CONDOR_CONFIG must be defined.');
    };

    if(!is_defined(CONDOR_CONFIG['hosts'])){
        error('CONDOR_CONFIG[hosts] should be defined as the hostnames of the head machines of the cluster.');
    };

    if(!is_defined(CONDOR_CONFIG['had_port'])){
        error('CONDOR_CONFIG[had_port] should be defined as the port used by had.');
    };

    if(!is_defined(CONDOR_CONFIG['repl_port'])){
        error('CONDOR_CONFIG[had_port] should be defined as the port used by th replication service.');
    };

    if(is_string(CONDOR_CONFIG['had_port']) && CONDOR_CONFIG['had_port'] == 'shared'){
        text = 'HAD_USE_SHARED_PORT = TRUE' + "\n";
        text = text + 'HAD_PORT = $(SHARED_PORT_PORT)' + "\n";
        text = text + 'HAD_SOCKET_NAME = had' + "\n";
    }else{
        text = 'HAD_PORT = ' + to_string(CONDOR_CONFIG['had_port']) + "\n";
        text = text + 'HAD_ARGS = -p $(HAD_PORT)' + "\n";
    };

    if(is_string(CONDOR_CONFIG['repl_port']) && CONDOR_CONFIG['repl_port'] == 'shared'){
        text = text + 'REPLICATION_USE_SHARED_PORT = TRUE' + "\n";
        text = text + 'REPLICATION_PORT = $(SHARED_PORT_PORT)' + "\n";
        text = text + 'REPLICATION_SOCKET_NAME = replication' + "\n";
    }else{
        text = text + 'REPLICATION_PORT = ' + to_string(CONDOR_CONFIG['repl_port']) + "\n";
        text = text + 'REPLICATION_ARGS = -p $(REPLICATION_PORT)' + "\n";
    };

    text = text + 'REPLICATION_LIST = ';

    foreach(i; h; CONDOR_CONFIG['hosts']){
        text = text + h + ':$(REPLICATION_PORT) ';
    };

    text = text + "\n";

    text = text + 'HAD_LIST = ';

    foreach(i; h; CONDOR_CONFIG['hosts']){
        text = text + h + ':$(HAD_PORT) ';
    };

    text = text + "\n";

    text = text + <<EOF;

HAD_CONTROLLEE          = NEGOTIATOR
HAD_CONNECTION_TIMEOUT = 10
HAD_USE_PRIMARY = true

DAEMON_LIST = $(DAEMON_LIST) HAD REPLICATION

HAD_USE_REPLICATION    = true

STATE_FILE = $(SPOOL)/Accountantnew.log

REPLICATION_INTERVAL                 = 300

MAX_TRANSFER_LIFETIME                = 300

HAD_UPDATE_INTERVAL = 300

MASTER_NEGOTIATOR_CONTROLLER    = HAD
MASTER_HAD_BACKOFF_CONSTANT     = 360

EOF

    text;
};
