unique template features/htcondor/client/job-transform;

variable CONDOR_REMOVE_REMOVED ?= false;
variable CONDOR_REMOVE_REMOVED_DELAY ?= '2*3600';
variable CONDOR_REMOVE_REMOVED_FUNCTION = <<EOF;
    copy_LeaveJobInQueue = "SubmitterLeaveJobInQueue";
    set_LeaveJobInQueue = (JobStatus == 3 && (time() - EnteredCurrentStatus) > %s) ? False : SubmitterLeaveJobInQueue
EOF

variable CONDOR_CONFIG = {
    if(CONDOR_REMOVE_REMOVED){

        if(!is_defined(SELF['job-transform'])){
            SELF['job-transform'] = dict();
        };

        SELF['job-transform']['LeaveInQueue'] = format(CONDOR_REMOVE_REMOVED_FUNCTION, CONDOR_REMOVE_REMOVED_DELAY); 

    };

    if(is_defined(SELF['job-transform']) && length(SELF['job-transform']) > 0){
        SELF['cfgfiles'] = append(SELF['cfgfiles'], dict(
            'name', 'job-transform',
            'contents', 'features/htcondor/templ/job-transform',
        ));
    };

    SELF;
};

