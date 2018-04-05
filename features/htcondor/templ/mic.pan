structure template features/htcondor/templ/mic;

'text' = {
       txt = <<EOF;

if defined MACHINE_RESOURCE_NAMES
  MACHINE_RESOURCE_NAMES = $(MACHINE_RESOURCE_NAMES) Phis
endif

MACHINE_RESOURCE_INVENTORY_Phis=/usr/libexec/condor/condor_mic_discovery

EOF

    txt;
};


