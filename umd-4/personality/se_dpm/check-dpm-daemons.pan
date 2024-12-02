unique template personality/se_dpm/check-dpm-daemons;

include 'components/filecopy/config';

variable DPM_CHECKDAEMONS_SCRIPT = 'check-dpm-daemons';
variable DPM_CHECKDAEMONS_FILE = '/usr/bin/' + DPM_CHECKDAEMONS_SCRIPT;


variable DPM_CHECKDAEMONS_TEMPLATE = <<EOF;
#!/bin/bash

service=/sbin/service

for daemon in DPM_DAEMONS
do
  #echo Checking $daemon status...
  ${service} $daemon status > /dev/null
  status=$?
  if [ $status -eq 2 -o $status -eq 1 ]         # Daemon is dead
  then
    echo "Restarting $daemon..."
    ${service} $daemon start
  elif [ $status -eq 3 ]
  then
    echo "Daemon $daemon has been intentionally stopped. Not restarted."
  elif [ $status -ne 0 ]
  then
    echo "$0: internal error during daemon $daemon check ($service returned unhandled status $status)"
  fi
done

EOF

# /software/components/dpmlfc has a very complicated schema...
variable DPM_ENABLED_SERVICES = {
    this = '';
    foreach (service; entries; value('/software/components/dpmlfc')) {
        if ( is_dict(entries) ) {
            foreach (host; host_params; entries) {
                if ( host == FULL_HOSTNAME ) {
                    if ( service == 'copyd' ) {
                        this = this + ' dpmcopyd';
                    } else if ( service == 'dpm' ) {
                        this = this + ' dpm';
                    } else if ( service == 'dpns' ) {
                        this = this + ' dpnsdaemon';
                    } else if ( service == 'gsiftp' ) {
                        this = this + ' dpm-gsiftp';
                    } else if ( service == 'rfio' ) {
                        this = this + ' rfiod';
                    } else if ( service == 'srmv1' ) {
                        this = this + ' srmv1';
                    } else if ( service == 'srmv2' ) {
                        this = this + ' srmv2';
                    } else if ( service == 'srmv22' ) {
                        this = this + ' srmv2.2';
                    } else if ( service == 'xroot' ) {
                        this = this + ' xrootd ';
                    };
                };
            };
        } else {
            if ( is_defined(entries) ) {
                debug ('Host list for service ' + service + ' has an unexpected format (should be a dict)');
            };
        };
    };
    this;
};


# Create script with appropriate daemon list to check

'/software/components/filecopy/services' = {
    if ( length(DPM_ENABLED_SERVICES) > 0 ) {
        this = replace('DPM_DAEMONS', DPM_ENABLED_SERVICES, DPM_CHECKDAEMONS_TEMPLATE);
        SELF[escape(DPM_CHECKDAEMONS_FILE)] = dict(
            'config', this,
            'owner', 'root:root',
            'perms', '0755'
        );
    };
    SELF;
};


# Add the script as a cron job if interval is greater than 0
include 'components/cron/config';
"/software/components/cron/entries" = {
    if ( is_defined(DPM_CHECKDAEMONS_INTERVAL) && (DPM_CHECKDAEMONS_INTERVAL > 0) ) {
        SELF[length(SELF)] = dict(
            "name", DPM_CHECKDAEMONS_SCRIPT,
            "user", "root",
            "frequency", '*/' + to_string(DPM_CHECKDAEMONS_INTERVAL) + " * * * *",
            "command", "PATH=/sbin:/bin:/usr/sbin:/usr/bin; " + DPM_CHECKDAEMONS_FILE,
        );
    };
    SELF;
};

include 'components/altlogrotate/config';
"/software/components/altlogrotate/entries" = {
    if ( is_defined(DPM_CHECKDAEMONS_INTERVAL) && (DPM_CHECKDAEMONS_INTERVAL > 0) ) {
        SELF[DPM_CHECKDAEMONS_SCRIPT] = dict(
            "pattern", "/var/log/" + DPM_CHECKDAEMONS_SCRIPT + ".ncm-cron.log",
            "compress", true,
            "missingok", true,
            "frequency", "weekly",
            "create", true,
            "ifempty", true,
        );
    };
    SELF;
};

