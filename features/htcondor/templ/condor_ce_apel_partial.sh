#!/bin/sh
# Run the processes of an HTCondor-CE + HTCondor accounting run

#Clean up the env to use the condor history rather than the condor-ce's
unset CONDOR_PARENT_ID SCHEDD_INTERFACE_VERSION CONDOR_PROCD_ADDRESS_BASE \
    CONDOR_CONFIG CONDOR_INHERIT CONDOR_PROCD_ADDRESS

/usr/share/condor-ce/condor_blah.sh # Make the blah file (CE/Security data)
/usr/share/condor-ce/condor_batch.sh  # Make the batch file (batch system job run times)
/usr/bin/apelparser # Read the blah and batch files in
