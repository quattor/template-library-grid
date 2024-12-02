unique template personality/argus/config;

# Base location of ARGUS services
variable ARGUS_LOCATION ?= '/usr/share/argus';
variable ARGUS_LOCATION_ETC ?= EMI_LOCATION_ETC + '/argus';
variable ARGUS_LOCATION_LOG ?= EMI_LOCATION_LOG + '/argus';

# Server hosting the PAP service
variable PAP_HOST ?= FULL_HOSTNAME;

# PAP standalone service port
variable PAP_PORT ?= 8150;

# Home directory of the PAP service
variable PAP_HOME ?= ARGUS_LOCATION + '/pap';

# Server hosting the PDP service
variable PDP_HOST ?= FULL_HOSTNAME;

# PDP standalone service port
variable PDP_PORT ?= 8152;

# Home directory for the PDP service
variable PDP_HOME ?= ARGUS_LOCATION + '/pdp';

# Server hosting the PEP service
variable PEP_HOST ?= FULL_HOSTNAME;

# PEP service port
variable PEP_PORT ?= 8154;

# Home directory for the PEP service
variable PEP_HOME ?= ARGUS_LOCATION + '/pepd';


#-----------------------------------------------------------------------------
# PAP Configuration
#-----------------------------------------------------------------------------

variable PAP_ENABLED = PAP_HOST == FULL_HOSTNAME;

include if (PAP_ENABLED) 'personality/argus/pap';


#-----------------------------------------------------------------------------
# PDP Configuration
#-----------------------------------------------------------------------------

variable PDP_ENABLED = {
    if (PDP_HOST == FULL_HOSTNAME) {
        true;
    } else {
        false;
    }
};

include if (PDP_ENABLED) 'personality/argus/pdp';


#-----------------------------------------------------------------------------
# PEP Configuration
#-----------------------------------------------------------------------------

variable PEP_ENABLED = {
    if (PEP_HOST == FULL_HOSTNAME) {
        true;
    } else {
        false;
    }
};

include if (PEP_ENABLED) 'personality/argus/pep';

variable ARGUS_SERVICES = {
    services = dict();
    if (PAP_ENABLED) {
        services['PAP'] = dict(
            "home", PAP_HOME,
            "initScript", '/etc/init.d/argus-pap'
        );
    };
    if (PDP_ENABLED) {
        services['PDP'] = dict(
            "home", PDP_HOME,
            "initScript", '/etc/init.d/argus-pdp'
        );
    };
    if (PEP_ENABLED) {
        services['PEP'] = dict(
            "home", PEP_HOME,
            "initScript", '/etc/init.d/argus-pepd'
        );
    };

    services
};


#
# ARGUS Startup Script
#

variable ARGUS_STARTUP_FILE = '/etc/init.d/argus';
variable ARGUS_STARTUP_CONTENTS = {
    contents = "#!/bin/bash\n";
    contents = contents + '###############################################################################' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '#   Copyright 2010-2012 by the Quattor team.' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '#   Startup script for Argus' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '#   chkconfig: 345 97 97' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '#   description:  Argus services startup script' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '#   Version: V1.5' + "\n";
    contents = contents + '#' + "\n";
    contents = contents + '#   Date: 15/10/2012' + "\n";
    contents = contents + '###############################################################################' + "\n";
    foreach (service; serviceinfo; ARGUS_SERVICES) {
        contents = contents + service + '_HOME=' + serviceinfo['home'] + "\n";
        contents = contents + 'export ' + service + '_HOME' + "\n";
    };
    contents = contents + "\n";
    contents = contents + 'if [ `id -u` -ne 0 ]; then' + "\n";
    contents = contents + '    echo "You need root privileges to run this script"' + "\n";
    contents = contents + '    exit 1' + "\n";
    contents = contents + 'fi ' + "\n";
    contents = contents + "\n";
    contents = contents + 'case "$1" in' + "\n";
    contents = contents + '    start)' + "\n";
    foreach (service; serviceinfo; ARGUS_SERVICES) {
        contents = contents + '        echo "##### ' + service + ' #####"' + "\n";
        contents = contents + '        ' + serviceinfo['initScript'] + ' status 2&> /dev/null' + "\n";
        contents = contents + '        result=$?' + "\n";
        contents = contents + '        if [ $result -ne 0 ]; then' + "\n";
        contents = contents + '            echo "Starting ' + service + ': "' + "\n";
        contents = contents + '            ' + serviceinfo['initScript'] + ' start' + "\n";
        contents = contents + '            sleep 5' + "\n";
        contents = contents + '        else' + "\n";
        contents = contents + '            echo "' + service + ' already running" 1>&2' + "\n";
        contents = contents + '        fi' + "\n";
    };
    contents = contents + '        ;; ' + "\n";
    contents = contents + '    stop)' + "\n";
    foreach (service; serviceinfo; ARGUS_SERVICES) {
        contents = contents + '        echo "##### ' + service + ' #####"' + "\n";
        contents = contents + '        echo "Shutting down ' + service + ': "' + "\n";
        contents = contents + '        ' + serviceinfo['initScript'] + ' stop' + "\n";
    };
    contents = contents + '        ;;' + "\n";
    contents = contents + '    status)' + "\n";
    foreach (service; serviceinfo; ARGUS_SERVICES) {
        contents = contents + '        echo "##### ' + service + ' #####"' + "\n";
        contents = contents + '        ' + serviceinfo['initScript'] + ' status' + "\n";
    };
    contents = contents + '        ;;' + "\n";
    contents = contents + '    *)' + "\n";
    contents = contents + '        echo "Usage: $0 {start|stop|status}"' + "\n";
    contents = contents + '        exit 1' + "\n";
    contents = contents + '        ;;' + "\n";
    contents = contents + 'esac' + "\n";
    contents = contents + "\n";
    contents = contents + 'exit 0' + "\n";

    contents;
};

include 'components/filecopy/config';
'/software/components/filecopy/services' = {
    npush(escape(ARGUS_STARTUP_FILE),
        dict(
            'config', ARGUS_STARTUP_CONTENTS,
            'owner', 'root',
            'perms', '0755',
        )
    )
};

include 'components/chkconfig/config';
'/software/components/chkconfig/service/argus/on' = '';
'/software/components/chkconfig/service/argus/startstop' = true;

