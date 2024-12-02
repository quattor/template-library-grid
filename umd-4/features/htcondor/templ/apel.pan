structure template features/htcondor/templ/apel;

'text' = {

    txt = 'APEL_CE_HOST = ' + FULL_HOSTNAME + "\n";
    txt = txt + 'APEL_BATCH_HOST = ' + CONDOR_CONFIG['hosts'][0] + "\n";
    txt = txt + <<EOF;

# The CE_ID is the CE, the port, and the batch system,
# ending with -condor to show the type of batch system.
APEL_CE_ID = $(APEL_CE_HOST):$(PORT)/$(APEL_BATCH_HOST)-condor

EOF

    txt = txt + 'APEL_OUTPUT_DIR = ' + CONDOR_CONFIG['apel_output_dir'] + "\n";
    txt = txt + <<EOF;

# This is cheating ...
APEL_SCALING_ATTR = 1

# Modify the apel executable if needed.
EOF

    txt = txt + 'SCHEDD_CRON_APEL_EXECUTABLE = ' + CONDOR_CONFIG['apel_script'] + "\n";

    txt;

};
