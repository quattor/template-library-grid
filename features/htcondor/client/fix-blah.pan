unique template features/htcondor/client/fix-blah;

variable HTCONDOR_FIX_JOB_CANCEL ?= true;

# Fixme: a bug in the blah RPM
include 'components/filecopy/config';

'/software/components/filecopy/services' = {

    SELF[escape('/usr/libexec/condor_status.sh')] = dict(
        'source', '/usr/libexec/condor_status.sh.save',
        'perms', '0755'
    );


    if(HTCONDOR_FIX_JOB_CANCEL){
        SELF[escape('/usr/libexec/condor_cancel.sh')] = dict(
            'config', file_contents('features/htcondor/templ/condor_cancel.sh'),
            'perms', '0755',
        );
    };
    SELF;
};
