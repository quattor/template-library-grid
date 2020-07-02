unique template features/htcondor/condorce;

include if(
    (is_defined(LRMS_SERVER) && (FULL_HOSTNAME == LRMS_SERVER)) ||
    (is_defined(CONDOR_CONFIG['host']) && (FULL_HOSTNAME == CONDOR_CONFIG['host'])) ||
    (is_defined(CONDOR_CONFIG['hosts']) && (index(FULL_HOSTNAME, CONDOR_CONFIG['hosts']) >= 0))
){

    'features/htcondor/server/service';

}else{

    'features/htcondor/client/service';
};