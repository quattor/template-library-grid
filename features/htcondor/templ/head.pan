structure template features/htcondor/templ/head;

'text' = {
       txt=if (CE_STATUS == "Closed" || CE_STATUS == "Queuing") {
              "NEGOTIATOR_ENABLE=false\n";
           } else {
              "NEGOTIATOR_ENABLE=true\n";
           };
       txt = txt + <<EOF;

DAEMON_LIST = $(DAEMON_LIST) COLLECTOR

if $(NEGOTIATOR_ENABLE)
    DAEMON_LIST = $(DAEMON_LIST) NEGOTIATOR
endif

ROTATE_HISTORY_DAILY = true
MAX_HISTORY_ROTATIONS = 10

NEGOTIATOR_POST_JOB_RANK = \
   (RemoteOwner =?= UNDEFINED) * \
   (ifThenElse(isUndefined(Mips), 1000, Mips) - \
   SlotID - 1.0e10*(Offline=?=True))


EOF
	foreach(i;opt;CONDOR_CONFIG['options']['head']){
		txt = txt +  opt['name'] + ' = ' + opt['value'] + "\n";
	};
	txt;
};


