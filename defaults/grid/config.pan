unique template defaults/grid/config;

include 'defaults/grid/functions';


# Include gLite update specific configuration that may be required further
include if_exists('update/init');


# This file defines a set of global variables for configuring the
# LCG/EGEE software.  Where the variables have sensible defaults,
# real values are given.  Others which must be changed are defined
# as 'undef'.  These will generate errors if you use them without
# redefining the value.

# This template should be included after any of your customizations
# but before using any of the standard LCG/EGEE templates in your
# machine definitions.

# Default architecture
variable PKG_ARCH_DEFAULT ?= 'x86_64';
variable PKG_ARCH_GLITE ?= PKG_ARCH_DEFAULT;

# SOURCE TREE LOCATIONS ---------------------------------------------------
# -------------------------------------------------------------------------

# Define the root locations of the MW software trees. These
# are used in many configuration files and for setting the ld.so.conf
# libraries.  You do not redefine these unless you install the LCG/EGEE
# software in non-standard locations.

# Installation root for the software.  Most of the grid software packages
# install by default in /opt.

variable INSTALL_ROOT ?= "";

# Location of Globus software.

variable GLOBUS_LOCATION ?= INSTALL_ROOT + '/usr';
variable GLOBUS_LOCATION_ETC ?= '/etc';

# Location of the gLite software.

variable GLITE_LOCATION       ?= '/usr';
variable GLITE_LOCATION_BIN   ?= GLITE_LOCATION + '/bin';
variable GLITE_LOCATION_SBIN  ?= GLITE_LOCATION + '/sbin';
variable GLITE_LOCATION_ETC   ?= '/etc';
variable GLITE_LOCATION_VAR   ?= '/var/glite';
variable GLITE_LOCATION_LOG   ?= '/var/log/glite';
variable GLITE_LOCATION_TMP   ?= '/tmp';

# Location of EMI software

variable EMI_LOCATION         ?= '';
variable EMI_LOCATION_ETC     ?= '/etc';
variable EMI_LOCATION_LOG     ?= '/var/log/emi';
variable EMI_LOCATION_VAR     ?= '/var';
variable EMI_LOCATION_TMP     ?= '/tmp';

# Script sourced by gLite services to define environment
variable GLITE_GRID_ENV_PROFILE ?= '/etc/profile.d/grid-env.sh';


# SECURITY LOCATIONS ------------------------------------------------------
# -------------------------------------------------------------------------

# Constants used for security-related files and directories.  Change these
# only if you keep these in non-standard locations.

variable SITE_DEF_GRIDSEC_ROOT ?= "/etc/grid-security";
variable SITE_DEF_HOST_CERT    ?= SITE_DEF_GRIDSEC_ROOT + "/hostcert.pem";
variable SITE_DEF_HOST_KEY     ?= SITE_DEF_GRIDSEC_ROOT + "/hostkey.pem";
variable SITE_DEF_GRIDMAP      ?= SITE_DEF_GRIDSEC_ROOT + "/grid-mapfile";
variable SITE_DEF_GRIDMAPDIR   ?= SITE_DEF_GRIDSEC_ROOT + "/gridmapdir";
variable SITE_DEF_CERTDIR      ?= SITE_DEF_GRIDSEC_ROOT + "/certificates";
variable SITE_DEF_VOMSDIR      ?= SITE_DEF_GRIDSEC_ROOT + "/vomsdir";

variable SITE_DEF_GROUPMAP     ?= INSTALL_ROOT + "/etc/lcmaps/groupmapfile";

#variable SITE_DPMLFC_GRIDMAP      ?= INSTALL_ROOT+"/etc/lcgdm-mapfile";
variable SITE_DPMLFC_GRIDMAP      ?= "/etc/lcgdm-mapfile";

# SITE DEFINITIONS --------------------------------------------------------
# -------------------------------------------------------------------------

# The contact email for the site.  The standard configuration uses this
# value where site support contacts are needed.  This must be a valid
# email address.

variable SITE_EMAIL ?= undef;

# The name of the site.  This must be the same name as listed in the
# GOC database.  This is a string.

variable SITE_NAME ?= undef;

# The site's geographical location (City, State, Country).  This is a
# string.

variable SITE_LOC ?= undef;

# The site's latitude and longitude.  These are double values.
# Try Getty Thesaurus of Geographic Names to find your location.
# http://www.getty.edu/research/conducting_research/vocabularies/tgn/

variable SITE_LAT ?= undef;
variable SITE_LONG ?= undef;

# The URL pointing to the site's web page.

variable SITE_WEB ?= undef;

# Site's DNS domain name.  This must be a fully-qualified domain
# name as a string.  It is used throughout the standard configuration.
# (E.g. SEDPM_STORAGE_DIR.)

variable SITE_DOMAIN ?= undef;

# The version of the installed grid software.
variable SITE_VERSION ?= "EMI_3";

# The contents of this list is added to SITE_OTHER_INFO if defined and non empty.
# Default should be appropriate for an EGEE production site.
variable SITE_OTHER_INFO_DEFAULT ?= dict(
    'GRID', 'EGEE',
    'EGEE_SERVICE', 'prod',
);

# Other information to be published in the site information.
# The two additional items used by LCG are the site's tier
# level (e.g. "TIER 2") and the site's support center (e.g.
# IN2P3-CC).  The value MUST be a list of strings.

variable SITE_OTHER_INFO ?= undef;

# Installation date of the software.  Format is year, month, day,
# hour, minutes, and seconds (with one hundredths given).  For
# example, 20050821120000Z.  (The 'Z' means GMT.)  This is a string.

variable INSTALL_DATE ?= undef;


# SERVICE LOCATIONS -------------------------------------------------------
# -------------------------------------------------------------------------

# Computing element (gatekeeper, may be a list) host and LRMS server.
# By default LRMS server is the first CE listed in CE_HOSTS.
# When CE_HOSTS is defined, CE_HOST is refefined to the current node if
# it present in the list CE_HOSTS, else it is left undefined.
variable CE_HOST ?= if (is_defined(CE_HOSTS) && (length(CE_HOSTS)) > 0) {
    if (index(FULL_HOSTNAME, CE_HOSTS) > -1) {
        FULL_HOSTNAME;
    } else {
        undef;
    };
} else {
    undef;
};

variable CE_HOSTS ?= if (is_defined(CE_HOST)) {
    list(CE_HOST);
} else {
    undef;
};

variable LRMS_SERVER_HOST ?= if (is_defined(CE_HOSTS)) {
    CE_HOSTS[0];
} else {
    undef;
};

# Fully qualified name of machine hosting the BLAH blparser, used by CREAM CE.
# This variable must be defined BEFORE batch system configuration.
# The BLparser must be installed on a machine where the batch system log
# files are available.
# When running no CREAM CE, it is possible to disable the BLPARSER.
variable BLPARSER_ENABLED ?= true;
variable BLPARSER_HOST ?= LRMS_SERVER_HOST;

# Site-level BDII: this used to be the CE but this is not a recommended choice.
# Every other machine type is better...
# This must be a fully qualified host name as a string.
variable SITE_BDII_HOST ?= CE_HOST;

# List of all site's SEs.  The default is the first listed unless changed.
# This must be a dict with one entry per SE (fully qualified name), the value being a
# dict defining SE params. Valid SE params are :
#   - type (required) : SE_classic, SE-dpm, SE_dcache
#   - arch (optional) : used to define GlueSEArchitecture. Defaults to 'multidisk'.
#                       Default normally appropriate.
#   - accessPoint (optional except for Classic SE) : common root of all VO areas
#                       (e.g. /var/storage/LCG for a classic SE)
#
variable SE_HOSTS ?= undef;

# If SE_HOSTS exists as a list (old format), convert to a dict.
# (of strings) even if you have only one.  The values
# must be fully qualified host names.
variable SE_HOST_NAMES = if (is_defined(SE_HOSTS) && is_list(SE_HOSTS)) {
    foreach (i;v;SE_HOSTS) {
        if (exists(SE_TYPES[v]) && is_defined(SE_TYPES[v])) {
            if (SE_TYPES[v] == 'disk') {
                SELF[v] = dict('type', 'SE_classic');
            } else {
                SELF[v] = dict('type', SE_TYPES[v]);
            };
        } else {
            error(format('SE_HOSTS deprecated format : missing entry index %d in SE_TYPES', i));
        };
        if (exists(SE_ACCESS[v]) && is_defined(SE_ACCESS[v])) {
            SELF[v]['accessPoint'] = SE_ACCESS[v];
        } else if (exists(STORAGE_DIRS[i]) && is_defined(STORAGE_DIRS[i])) {
            SELF[v]['accessPoint'] = STORAGE_DIRS[i];
        };
        if (exists(SE_ARCH[v]) && is_defined(SE_ARCH[v])) {
            SELF[v]['arch'] = SE_ARCH[v];
        };
    };
    SELF;
} else {
    null;
};

variable SE_HOSTS = if (is_null(SE_HOST_NAMES)) {
    SELF;
} else {
    null;
};

variable SE_HOSTS ?= SE_HOST_NAMES;

# A site's File Catalog (LFC).
variable LFC_PORT ?= 5010;
variable LFC_DLI_PORT ?= 8085;
variable LFC_HOST ?= undef;
# Convert LFC_HOST to a dict if a string
variable LFC_HOSTS ?= if (is_string(LFC_HOST)) {
    SELF[LFC_HOST] = dict();
    SELF;
} else {
    LFC_HOST;
};

variable LFC_HOST_DEFAULT ?= undef;

# Site Resource Broker (normally defined per VO)
variable RB_HOST ?= undef;

# Site default MyProxy server (may be outside site)
variable PX_HOST ?= undef;

# Top level BDII (BDII_HOST is deprecated)
variable BDII_HOST ?= undef;
variable TOP_BDII_HOST ?= BDII_HOST;

# The registry for R-GMA.  There is currently exactly one of these. Do
# not change the value below unless you are running on a separate grid.

variable REG_HOST ?= "lcgic01.gridpp.rl.ac.uk";

# GRIS port.  This is used to publish information from services.

variable GRIS_PORT ?= 2135;

# RLS (Replica Location Service) port (also used  by LFC and DPM/DPNS).
variable RLS_PORT ?= 5010;
variable DLI_PORT ?= 8085;

# The location of a VO BOX on a site.
variable VOBOX_HOST ?= undef;

# A X509 to Kerberos Authentication Server.  Used at sites with
# experiment software under AFS.
variable GSSKLOG_HOST ?= undef;

# Profile scripts used to define environment variables at login

# Used on all machines
variable GLITE_ENV_SCRIPT_DEFAULT ?= '/etc/profile.d/env.sh';
# Used by most of gLite services
variable GLITE_GRID_ENV_PROFILE ?= '/etc/profile.d/grid-env.sh';


# GSISSH CONFIGURATION ----------------------------------------------------
# -------------------------------------------------------------------------
variable GSISSH_PORT ?= 1975;


# MYPROXY CONFIGURATION ---------------------------------------------------
# -------------------------------------------------------------------------

# If you run a MyProxy server, you need to provide the list of DNs for
# the trusted resource brokers.  The RBs use the MyProxy server for proxy
# renewal. This must be a list of strings.

variable GRID_TRUSTED_BROKERS ?= undef;


# SUPPORTED VIRTUAL ORGANIZATIONS -----------------------------------------
# -------------------------------------------------------------------------

# This is a list of the supported virtual organizations.  At a minimum,
# you must support "dteam".  This must be a list of strings.  (Usually the
# short, nicknames of the VOs.)

variable VOS ?= list(
    "dteam",
    "ops",
);

# VOS_SITE_PARAMS can be used  to specify site specific parameters for VOs
# Entry "DEFAULT", if present, is used to define site specific default parameters.
# Other entries must correspond to a VO name.
# Value is the name of a structure template defining parameters.
variable VOS_SITE_PARAMS ?= dict();

variable ALLVOS_INCLUDE ?= if (is_string(VOS) && (VOS == 'ALL')) {
    if_exists('vo/params/allvos');
} else {
    undef;
};

include ALLVOS_INCLUDE;

variable VOS_TMP ?= if (is_string(VOS)) {
    if (VOS == 'ALL') {
        if (exists(ALLVOS) && is_list(ALLVOS)) {
            ALLVOS;
        } else {
            error('Variable ALLVOS undefined or not a list');
        };
    } else {
        list(VOS);
    };
} else {
    VOS;
};
variable VOS = undef;
variable VOS = VOS_TMP;


# MON BOX PARAMETERS (R-GMA) ----------------------------------------------
# -------------------------------------------------------------------------

# A "monitoring" box.  Contains the site's R-GMA server and usually
# the GridIce monitoring server.  The R-GMA server is required for a
# site.

variable MON_HOST ?= undef;

# The password for the MySQL database on the MON box.  Choose something
# which will not be easy to guess.

variable MON_MYSQL_PASSWORD ?= undef;


# gLite WMS ---------------------------------------------------------------
# -------------------------------------------------------------------------

variable WMSLB_MYSQL_PASSWORD ?= undef;
variable WMS_OUTPUT_STORAGE_DEFAULT ?= '${HOME}/JobOutput';

# STORAGE ELEMENT PARAMETERS ----------------------------------------------
# -------------------------------------------------------------------------

# Whether or not RFIO is an enabled protocol for the SE.  This is a
# boolean value. This is normally defined by SE configuration templates
# with the appropriate value for the SE type used.
variable RFIO_ENABLED ?= undef;

# The root area for the VO-specific storage areas.  If these are not
# available from a single root, then changes in the default templates
# must be made.  These are strings.

variable SE_STORAGE_DIR ?= undef;
variable SEDPM_STORAGE_DIR ?= undef;

# List of the storage directories for the SEs.  This should contain
# the list (strings) of the directories above.

variable SE_STORAGE_DIRS ?= undef;

# Ports for SE related services

variable DPM_PORT ?= 5015;
variable DPNS_PORT ?= 5010;
variable GSIFTP_PORT ?= 2811;
variable RFIO_PORT ?= 5001;
variable SRMV1_PORT ?= 8443;
variable SRMV2_PORT ?= 8444;
variable SRMV2_2_PORT ?= 8446;


# COMPUTING ELEMENT PARAMETERS --------------------------------------------
# -------------------------------------------------------------------------

# Export the home areas as an NFS volume.
# This value is normally defined during VO configuration according to
# the contents of WN_SHARED_AREAS. Avoid explicit declaration, except if
# really required.
variable CE_SHARED_HOMES ?= undef;

# CREAM CE: default directory where the sandbox is located on the CE.
# This variable can have one entry per host + a 'DEFAULT' entry.
variable CREAM_SANDBOX_DIRS ?= dict('DEFAULT', '/var/cream_sandbox');

# On a CREAM CE, defines where the sandbox directory must be mounted on WNs.
# If undefined, do not mount sandbox directory with NFS.
# CREAM_SANDBOX_MPOINTS is a dict whith one entry per CE host whose sandbox dir must be NFS-mounted.
# Note: as the mount point must be different for the sandbox directory of each configured CE, there is no default.
variable CREAM_SANDBOX_MPOINTS ?= undef;

# On a CREAM CE with a shared sandbox directory, define the protocol to use for sharing.
# Default (if the variable is undefined) is NFS.
# This variable may contain one entry per CE host and/or a 'DEFAULT' entry.
#variable CREAM_SANDBOX_SHARED_FS ?= dict('DEFAULT', 'nfs');

# Configure SSH host based authentication between CE and WNs
# Normally, default (undef) should not be modified : it will determine the need
# for SSH from the NFS configuration.
# If true, force the configuration of SSH between CE and WNs.
# If false, prevent the configuration even if it seems required.
variable CE_USE_SSH ?= undef;

# Define batch system to use. Currently supported values are :
#   - torque1 : Torque v1 with MAUI
#   - torque2 : Torque v2 with MAUI
#   - condor : HTCondor
# Default is torque1 if CE_BATCH_SYS is defined to pbs (backward compatibility)
variable CE_BATCH_NAME ?= if (exists(CE_BATCH_SYS) && is_defined(CE_BATCH_SYS) && match(CE_BATCH_SYS, "^(lcg)?pbs$")) {
    'torque1';
} else {
    if (is_defined(CE_BATCH_SYS) && (CE_BATCH_SYS == "condor")) {
            'condor';
    } else {
            undef;
    };
};

# LCAS/LCMAPS PARAMETERS --------------------------------------------------
# -------------------------------------------------------------------------

variable LCAS_FLAVOR ?= 'glite';
variable LCMAPS_FLAVOR ?= 'glite';
variable MKGRIDMAP_FLAVOR ?= 'glite';


# Batch system and CE Job manager.
# For Torque must be 'pbs'.
variable CE_BATCH_SYS ?= if (exists(CE_BATCH_NAME) && is_defined(CE_BATCH_NAME) && match(CE_BATCH_NAME, '^torque[12]?$')) {
    'pbs';
} else {
    if (is_defined(CE_BATCH_NAME) && CE_BATCH_NAME == 'condor') {
        'condor';
    } else {
        undef;
    };
};
variable CE_JM_TYPE ?= CE_BATCH_SYS;

# Used by several templates to trig install of Torque/MAUI components
# Should not be redefined in normal circumstances
variable CE_TORQUE ?= exists(CE_BATCH_SYS) && is_defined(CE_BATCH_SYS) && match(CE_BATCH_SYS, "^(lcg)?pbs$");

# Set GIP_CE_USE_MAUI to true if you want to use MAUI to collect data about CE usage,
# instead of Torque. Required to support advanced MAUI features like
# standing reservations.
# When using MAUI-based GIP, it is possible to run GIP plugins on the
# Torque/MAUI server and cache the output for later retrieval by GIP.
# This is particularly  useful when running multiple CEs sharing the same
# Torque/MAUI cluster as not all of them can have access to MAUI information.
# Default for GIP_CE_USE_CACHE is false when there is only 1 CE
# (backward compatibility) but it is recommended to set it to true in any
# case as cache mode protect over MAUI not responding properly to
# commands under heavy loads.
variable GIP_CE_USE_CACHE ?= if (is_defined(CE_HOSTS) && ((length(CE_HOSTS) > 1) || (CE_HOSTS[0] != LRMS_SERVER_HOST))) {
    true;
} else {
    false;
};
variable GIP_CE_USE_MAUI ?= true;
variable GIP_CE_MAUI_CACHE_FILE ?= undef;      # Default should be appropriate
variable GIP_CE_MAUI_CACHE_REFRESH ?= undef;   # Default should be appropriate

# The following information is indicative of the minimum values available
# on a site.  These are published into the information system.  ALL VALUES
# ARE STRINGS!

variable CE_CPU_MODEL ?= undef;
variable CE_CPU_VENDOR ?= undef;
variable CE_CPU_SPEED ?= undef;
variable CE_SMPSIZE ?= undef;

# CPU Performance (SpecInt 2000 and SpecFloat 2000).
# Benchmarks at http://www.specbench.org/osg/cpu2000/results/cint2000.html

variable CE_SI00 ?= undef;
variable CE_SF00 ?= undef;

# Operating system information.
variable CE_OS ?= undef;
variable CE_OS_RELEASE ?= undef;
variable CE_OS_VERSION ?= if (is_defined(CE_OS) && (CE_OS == "Scientific Linux")) {
    "SL";
} else {
    undef;
};

# Memory information (minima in MB)
variable CE_MINPHYSMEM ?= undef;
variable CE_MINVIRTMEM ?= undef;

# CE Close SE definition.
# Can be either a list or a dict of list. In the latter case, there may be
# one entry per VO (key is the VO name) and one default entry (key is 'DEFAULT').
# If not defined, defaults to SE_HOSTS list. Define as 'undef' to remove any
# close SE definition.
variable CE_CLOSE_SE_LIST ?= if (exists(SE_HOST_DEFAULT) && is_defined(SE_HOST_DEFAULT)) {
    return(list(SE_HOST_DEFAULT));
} else {
    if (exists(SE_HOSTS) && is_defined(SE_HOSTS) && (length(SE_HOSTS) > 0)) {
        se_list = SELF;
        foreach (name;params;SE_HOSTS) {
            se_list = append(name);
        };
        se_list;
    } else {
        null;
    };
};

# CE default SE definition.
# Can be either a string or a dict of string. In the latter case, there may be
# one entry per VO (key is the VO name) and one default entry (key is 'DEFAULT')
# Default is to use first SE in CE_CLOSE_SE_LIST.
#variable CE_DEFAULT_SE_LIST ?= undef;

# SE_HOST_DEFAULT_SC3 is deprecated
#variable SE_HOST_DEFAULT_SC3 ?= SE_HOST_DEFAULT;

# Network connectivity from worker nodes.  These should either be
# the strings "TRUE" or "FALSE".   The defaults assume the normal case
# where outbound IP connectivity is permitted, but not inbound.
variable CE_OUTBOUNDIP ?= "TRUE";
variable CE_INBOUNDIP  ?= "FALSE";

# Alternate name of CE_HOST when WNs are in a private network
# Must match CE_HOST name on the private network
variable CE_PRIV_HOST ?= undef;

# Run time environment variables.  This must be a list of strings.
# It usually contains the LCG versions and some service information.

variable CE_RUNTIMEENV_DEFAULT = list(
    "EMI-3_0",
);
variable CE_RUNTIMEENV_SITE ?= null;
variable CE_RUNTIMEENV ?= add_ce_runtime_env(CE_RUNTIMEENV_DEFAULT, CE_RUNTIMEENV_SITE);

# CE_STATUS can be used to set a non default status (e.g. Closed) for the CE.
# Generally set on a per CE basis (in CE machine profile).
# CE_STATUS valid values are :
#   - 'Production' : enabled=true, started=true (Defaults)
#   - 'Queuing' (job accepted but not executded) : enabled=true, started=false
#   - 'Draining' (no new job accepted) : enabled=false, started=true
#   - 'Closed' : enabled=false, started=false
variable CE_STATUS ?= 'Production';

# CE_KEEP_RUNNING_QUEUES is a list of queues that must be kept running even
# when draining/closing the CE.
# Default : dteam, ops
variable CE_KEEP_RUNNING_QUEUES ?= list('dteam', 'ops');

# NOTE; that the default configuration assumes that there is one
# queue per VO.  If you want to change this default, define the
# variable CE_QUEUES.
#
# This must contain an dict with the vos value defined.  The
# vos key must contain a list with the names of the authorized
# VOs.
#
# The CE_QUEUES variable may also contain an attributes key.
# If defined it must contain an dict with the specific queue
# attributes.  These will be merged with the values in
# CE_QUEUE_DEFAULTS.
# Default list of queues is defined in the LRMS configuration template.

variable CE_QUEUES ?= undef;

# Queues to configure for non grid usage : they will not be advertized
# into the BDII and there will be no job manager associated with them.
# The structure of CE_LOCAL_QUEUES is the same as CE_QUEUES except that
# key for queue names is 'qname' instead of 'vos'.
variable CE_LOCAL_QUEUES ?= undef;


# Get close SE for each VO.
# Close SE is defined with variable CE_CLOSE_SE_LIST which
# can be a string, a list of string or dict of string or list.
# If the variable is a string or a list, it is assumed to be
# the default value that applies to all VOs.
# A list is required if there are several close SEs, a string can be
# used when there is only one close SE.
# If the variable is a dict, keys are VO names or DEFAULT.
# For the queue, only DEFAULT entry is taken into account.
# For the VO view, the VO entry has priority if it exists.
# It is valid not having a close SE defined, there may be several
# close SE per VO.
variable CE_VO_CLOSE_SE = {
    foreach (i;vo;VOS) {
        close_se = undef;

        if (exists(CE_CLOSE_SE_LIST) && is_defined(CE_CLOSE_SE_LIST)) {
            if (is_string(CE_CLOSE_SE_LIST) || is_list(CE_CLOSE_SE_LIST)) {
                close_se = CE_CLOSE_SE_LIST;
            } else if (is_dict(CE_CLOSE_SE_LIST)) {
                if (exists(CE_CLOSE_SE_LIST[vo]) && is_defined(CE_CLOSE_SE_LIST[vo])) {
                    close_se = CE_CLOSE_SE_LIST[vo];
                };
                if (!is_defined(close_se) && exists(CE_CLOSE_SE_LIST['DEFAULT']) && is_defined(CE_CLOSE_SE_LIST['DEFAULT'])) {
                    close_se = CE_CLOSE_SE_LIST['DEFAULT'];
                };
            } else {
                error('CE_CLOSE_SE_LIST must be either a string, a list or dict (non empty)');
            };
        };

        if (is_defined(close_se) && (length(close_se) > 0)) {
            if (is_string(close_se)) {
                SELF[vo] = list(close_se);
            } else if (is_list(close_se)) {
                SELF[vo] = close_se;
            } else {
                error(format('Invalid close SE for VO %s : must be a string or list', vo));
            };
        } else {
            SELF[vo] = undef;
        };
    };

    SELF;
};

# Get VO-independent default SE (used with queues)
# 2 variables can be used to define a default SE :
#   - CE_DEFAULT_SE_LIST : a string or dict of strings
#   - CE_CLOSE_SE_LIST : a list or dict of list
# If the variable is a dict, keys are VO names or DEFAULT.
# For the VO-independent default SE, only DEFAULT entry is taken into account.
# It is valid not having a default SE defined.
variable CE_DEFAULT_SE = {
    ce_default_se = undef;
    if (exists(CE_DEFAULT_SE_LIST) && is_defined(CE_DEFAULT_SE_LIST)) {
        if (is_string(CE_DEFAULT_SE_LIST)) {
            ce_default_se = CE_DEFAULT_SE_LIST;
        } else if (is_dict(CE_DEFAULT_SE_LIST)) {
            if (exists(CE_DEFAULT_SE_LIST['DEFAULT']) && is_defined(CE_DEFAULT_SE_LIST['DEFAULT'])) {
                ce_default_se = CE_DEFAULT_SE_LIST['DEFAULT'];
            };
        } else {
            error('CE_DEFAULT_SE_LIST must be either a string or a dict');
        };
    };

    if (!is_defined(ce_default_se) && exists(CE_CLOSE_SE_LIST) && is_defined(CE_CLOSE_SE_LIST)) {
        if (is_string(CE_CLOSE_SE_LIST) || is_list(CE_CLOSE_SE_LIST)) {
            if (length(CE_CLOSE_SE_LIST) > 0) {
                ce_default_se = CE_CLOSE_SE_LIST;
            };
        } else if (is_dict(CE_CLOSE_SE_LIST)) {
            if (exists(CE_CLOSE_SE_LIST['DEFAULT']) && is_defined(CE_CLOSE_SE_LIST['DEFAULT']) && (length(CE_CLOSE_SE_LIST['DEFAULT']) > 0)) {
                ce_default_se = CE_CLOSE_SE_LIST['DEFAULT'];
            };
        } else {
            error('CE_CLOSE_SE_LIST must be either a string, a list or a dict');
        };
    };

    if (is_defined(ce_default_se) && (length(ce_default_se) > 0)) {
        if (is_string(ce_default_se)) {
            return(ce_default_se);
        } else if (is_list(ce_default_se)) {
            return(ce_default_se[0]);
        } else {
            error('Invalid default SE : must be a string or list');
        };
        ce_default_se;
    } else {
        undef;
    };
};

# Get per VO default SE (used for VOViews and to define environment
# variables on WNs and UIs)
# To find per VO default SE, look for:
#  1- CE_DEFAULT_SE_LIST[vo]
#  2- CE_DEFAULT_SE_LIST['DEFAULT']
#  3- CE_CLOSE_SE_LIST[vo]
#  1- CE_DEFAULT_SE which at this point can only be CE_CLOSE_SE_LIST['DEFAULT']
# It is valid not having a default SE defined.
variable CE_VO_DEFAULT_SE = {
    foreach (i;vo;VOS) {
        se_default = undef;

        if (exists(CE_DEFAULT_SE_LIST) && is_defined(CE_DEFAULT_SE_LIST)) {
            # CE_DEFAULT_SE_LIST have already been checked to have a valid type
            if (is_string(CE_DEFAULT_SE_LIST)) {
                se_default = list(CE_DEFAULT_SE_LIST);
            } else if (exists(CE_DEFAULT_SE_LIST[vo]) && is_defined(CE_DEFAULT_SE_LIST[vo])) {
                se_default = CE_DEFAULT_SE_LIST[vo];
            } else if (exists(CE_DEFAULT_SE_LIST['DEFAULT']) && is_defined(CE_DEFAULT_SE_LIST['DEFAULT'])) {
                se_default = CE_DEFAULT_SE_LIST['DEFAULT'];
            };
        };

        if (!is_defined(se_default) && is_defined(CE_VO_CLOSE_SE[vo])) {
            se_default = CE_VO_CLOSE_SE[vo][0];
        };

        if (!is_defined(se_default)) {
            se_default = CE_DEFAULT_SE;
        };

        if (is_defined(se_default) && (length(se_default) > 0)) {
            SELF[vo] = se_default;
        } else {
            SELF[vo] = undef;
        };
    };

    SELF;
};


# Shared Gridmapdir --------------------------------------------------------
# ---------------------------------------------------------------------------

# Define to the shared gridmapdir path as seen on "client" machines.
# Default: no shared griddmapdir
variable GRIDMAPDIR_SHARED_PATH ?= undef;

# Protocol to use for sharing gridmapdir.
# If NFS, NFS configuration will be added automatically.
# Default: NFS.
variable GRIDMAPDIR_SHARED_PROTOCOL ?= 'nfs';

# Host serving the shared gridmapdir, if any.
# No default, required if GRIDMAPDIR_SHARED_PATH is defined.
variable GRIDMAPDIR_SHARED_SERVER ?= if (is_defined(GRIDMAPDIR_SHARED_PATH) && match(to_lowercase(GRIDMAPDIR_SHARED_PROTOCOL), '^nfs')) {
    error('GRIDMAPDIR_SHARED_SERVER must be defined if GRIDMAPDIR_SHARED_PATH is defined and GRIDMAPDIR_SHARED_PROTOCOL is NFS');
} else {
    undef;
};

# Variable allowing to restrict the nodes using the shared gridmapdir.
# Default: all the CEs sharing the same configuration.
variable GRIDMAPDIR_SHARED_CLIENTS ?= CE_HOSTS;

# BDII CONFIGURATION ------------------------------------------------------
# -------------------------------------------------------------------------
variable BDII_PORT ?= 2170;
variable BDII_PASSWD ?= undef;

# URL of a file containing information system references for all sites.
# This is used for a "top-level" BDII associated usually with a resource
# broker.  The value below is the default for production sites.
variable BDII_UPDATE_URL ?= "http://lcg-bdii-conf.cern.ch/bdii-conf/bdii.conf";

# This is the dict of GRIS URLs on a site for collecting service and
# status information.  This must be a dict where the keys are (arbitrary)
# names of services and the value is an LDAP URL.
#
# For example:
# variable BDII_URLS = dict("CE", "ldap://ce.example.org:2135/mds-vo-name=local,o=grid");
variable BDII_URLS ?= undef;


# GLOBUS DEFINITIONS --------------------------------------------------------
# ---------------------------------------------------------------------------

variable GLOBUS_TCP_PORT_RANGE_MIN ?= '20000';
variable GLOBUS_TCP_PORT_RANGE_MAX ?= '25000';


# NFS DEFINITIONS -----------------------------------------------------------
# ---------------------------------------------------------------------------

# WN_SHARED_AREAs is a dict containing 1 entry for each file system shared
# between CE and WNs. Generally the filesystem is shared by NFS but this is
# not required (can be AFS...). With NFS, the server is not required to be the CE,
# it can be any node (e.g. a dedicated NFS server) and the NFS server is not
# required to be managed by Quattor.
#
# On the CE, WNs and possibly NFS server if managed by Quattor, necessary actions
# will be undertaken to mount the file system as a server or client, depending
# on entry value. A node is considered a filesystem server if it is listed as
# the host in the entry value. This is evaluated filesystem per filesystem :
# there is no requirement to have the same server for all filesystems.
#
# For each NFS mount point, the associated value can be a host name (assume mount
# point is the same on server and client) or host:/path if the mount point on
# the server (/path) is different from the client (mount point).
# For non NFS mount pointsi or mount points not managed by NFS templates,
# the value must be 'undef'.
#
# Listing a shared filesystem, even if not managed by Quattor allows to
# the batch system to take advantage of the shared filesystem.
#
# Warning : Filesystem mount point must be escaped.
#
# For backward compatibility, if WN_SHARED_AREAS is undefined :
#    - If WN_NFS_AREAS is defined, WN_NFS_AREAS is used.
#    - If CE_NFS_ENABLED (deprecated) is true, it is initialized with one
#      entry for /home using CE_HOST as NFS server.
#
variable WN_SHARED_AREAS ?= if (exists(WN_NFS_AREAS) && is_defined(WN_NFS_AREAS)) {
    WN_NFS_AREAS;
} else {
    if (exists(CE_NFS_ENABLED) && is_defined(CE_NFS_ENABLED) && CE_NFS_ENABLED) {
        dict(escape("/home"), CE_HOST);
    } else {
        undef;
    };
};


# Backward compatbility for NFS_ENABLED renamed to NFS_SERVER_ENABLED.
variable NFS_ENABLED ?= undef;
variable NFS_SERVER_ENABLED ?= NFS_ENABLED;

# NFS_CLIENT_ENABLED: enable/disable NFS configuration based on WN_SHARED_AREAS.
# This variable is a 3-state variables:
#   - false: do not configure NFS client
#   - true: always configure NFS client, even though not required based on WN_SHARED_AREAS
#   - undef: configure NFS client if there are NFS-based file systems in WN_SHARED_AREAS not
#            not served by the current node.
# Default value is false.
variable NFS_CLIENT_ENABLED_TMP = {
    if (exists(NFS_CLIENT_ENABLED)) {
        SELF;
    } else {
        false;
    };
};
variable NFS_CLIENT_ENABLED = NFS_CLIENT_ENABLED_TMP;

# NFS export ACL definition
# The following settings are used to enable NFS mount access from CE/WNs or other
# nodes. By default only CE and worker nodes are given access to NFS server.
# Several variables allow to customize the NFS export ACL :
#   - NFS_CE_HOSTS : list of CE hosts requiring access to NFS server (default is CE_HOST)
#   - NFS_WN_HOSTS : list of WN hosts requiring access to NFS server (default is WN_HOSTS)
#   - NFS_LOCAL_CLIENTS : list of other local hosts requiring access to NFS server
#
# Both of these variables can be a string, a list or a dict. A string value is
# interpreted as a list with one element. When specified as a list or string, the value must be a
# regexp matching name of nodes that must be given access to NFS server. The access right is the value
# of NFS_DEFAULT_RIGHTS. When specified as a dict, the key must be an escaped regexp and the value is
# the access rights.
#
# When possible, this is recommended to replace default value for NFS_WN_HOSTS by one or several regexps
# matching WN names.
#

# Export options for CE hosts.
# NFS_CE_HOSTS is a dict where the key must be the escaped host name.
variable NFS_CE_HOSTS ?= {
    ce_def_right = '(rw, no_root_squash)';
    if (exists(SITE_CE_HOSTS) && is_defined(SITE_CE_HOSTS)) {
        if (is_string(SITE_CE_HOSTS)) {
            ce_hosts = list(SITE_CE_HOSTS);
        } else {
            ce_hosts = SITE_CE_HOSTS;
        };
    } else {
        ce_hosts = CE_HOSTS;
    };
    # If this is already a dict, just use it
    if (is_list(ce_hosts)) {
        foreach (i;host;ce_hosts) {
            SELF[escape(host)] =  ce_def_right;
        };
        SELF;
    } else if (is_defined(ce_hosts)) {
        ce_hosts;
    } else {
        debug('CE host list is empty');
        undef;
    };
};

variable NFS_WN_HOSTS ?= if (exists(SITE_WN_HOSTS) && is_defined(SITE_WN_HOSTS)) {
    SITE_WN_HOSTS;
} else if (exists(WORKER_NODES) && is_defined(WORKER_NODES)) {
    WORKER_NODES;
} else {
    undef;
};

variable NFS_LOCAL_CLIENTS ?= if (exists(LOCAL_NFS_CLIENT) && is_defined(LOCAL_NFS_CLIENT)) {
    LOCAL_NFS_CLIENT;
} else {
    undef;
};

# NFS clients per file system.
# Key is a filesystem name (escaped) matching an entry in WN_SHARED_AREAS, value is a dict
# of nodes where to mount the file system on. In each element of the dict, key is a nodename, value
# is optional access rights or undef.
# In additition, there is an entry 'DEFAULT' for the file systems not listed explicitly
# Default for 'DEFAULT' entry is NFS_CE_HOSTS + NFS_WN_HOSTS + NFS_LOCAL_CLIENTS.
variable NFS_CLIENT_HOSTS = {
    if (!exists(SELF['DEFAULT']) || !is_defined(SELF['DEFAULT'])) {
        host_lists = list(NFS_CE_HOSTS, NFS_WN_HOSTS, NFS_LOCAL_CLIENTS);
        SELF['DEFAULT'] = dict();
        foreach (i;host_list;host_lists) {
            if (is_string(host_list)) {
                SELF['DEFAULT'][escape(host_list)] = undef;
            } else if (is_list(host_list)) {
                foreach (j;host;host_list) {
                    SELF['DEFAULT'][escape(host)] = undef;
                }
            } else if (is_dict(host_list)) {
                SELF['DEFAULT'] = merge(SELF['DEFAULT'], host_list);
            } else if (is_defined(host_list)) {
                error('Invalid format for one of the NFS_xxx_HOSTS lists');
            };
        };
    };
    SELF;
};

# NFS_DEFAULT_RIGHTS must contain a DEFAULT entry and may contain one entry per
# file system (escaped) specifying the default to apply to this particular file system.
# By default, enable root squashing on all file systems, except home directory parents
# (required for account configuration).
# These defaults don't apply to hosts with specific rights defined, like CE.
# Default value for this variable is defined in NFS server configuration (features/nfs/server/config)

# NFS_DEFAULT_RIGHTS must contain a DEFAULT entry and may contain one entry per
# file system (escaped) specifying the default to apply to this particular file system.
# By default, enable root squashing on all file systems, except home directory parents
# (required for account configuration).
# These defaults don't apply to hosts with specific rights defined, like CE.
# Default value for this variable is defined in NFS server configuration (features/nfs/server/config)


# Build SITE_NFS_ACL as a dict with one entry per file system (escaped).
# Value is the export list for the file system.
# Default value for this variable is defined in NFS server configuration (features/nfs/server/config)

# When NFS_AUTOFS is true, autofs is used to mount NFS filesystems
# rather than fstab. It is recommended to use autofs to avoid startup
# synchronization nightmares between NFS servers and clients...
# Default value for this variable is defined in NFS client configuration (features/nfs/client/config)


# Variable NFS_THREADS is used to configure a non default number of NFS
# threads on NFS servers. This is a dict with 1 entry per NFS server node
# where an explicit number of threads must be defined. A host name present
# in the list but not used as a NFS server is just ignored.
#
# A typical example is :
# variable NFS_THREADS = dict(
#    CE_HOST, 16,
#    SE_HOST_DEFAULT, 16,
#);
variable NFS_THREADS ?= undef;

# This variable, if true, prevents definition of EDG_WL_SCRATCH environment
# variable to a local directory when /home is NFS mounted.
# It is strongly advised to keep this variable to false, as having
# EDG_WL_SCRATCH on a NFS area with a large number of workers can
# result in significant performance penalty on WNs and NFS server.
variable WN_NFS_WL_SCRATCH ?= false;

# NFS_CLIENT_VERSION and NFS_CLIENT_DEFAULT_VERSION are dicts that allow to specify
# NFS version to use on the client.
# In NFS_CLIENT_VERSION, the key is a host name.
# In NFS_CLIENT_DEFAULT_VERSION, the key is either 'DEFAULT' or a an escaped regexp that
# will matched again the host name of the current machine.
# If no 'DEFAULT' entry is defined and no other entry matches,  NFS_DEFAULT_VERSION is used.
# See features/nfs/init.tpl for more information

# Default mount options used on NFS clients (hard always added)
variable NFS_DEFAULT_MOUNT_OPTIONS ?= "rw,noatime";


# Variable NFS_MOUNT_OPTS is a dict that can be used to specify specific
# mount options for a filesystem. Key must be the mount point escaped, as
# in WN_SHARED_AREAS
# variable NFS_MOUNT_OPTS = dict();


# VO SPEFICIC AREAS  --------------------------------------------------------
# ---------------------------------------------------------------------------

# Area for the installation of the experiment software
# If on your WNs you have predefined shared areas where VO managers can
# pre-install software, then these variables should point to these areas.
# If you do not have shared areas and each job must install the software,
# then these variables should contain a dot (.)
#
# This is an dict where the keys are the VO names (as in the VOS variable)
# and the value is the absolute path to the area.
#
# If an entry DEFAULT is present, a SW area will be created for each VO
# without an explicit SW area, using the value as the SW area root path
# and adding 'VO name+SWmanager_account_suffix' or VO name to build the full path
# according to VO_SW_AREAS_USE_SWMGR.
#
# For example:
# variable VO_SW_AREAS ?= dict(
#                                  "alice", "/home/alicesgm",
#                                  "atlas", "/home/atlassgm",
#);
#
# For backward compatibility, defaults to WN_AREA if defined.
# WN_AREA use is deprecated.

variable WN_AREA ?= undef;
variable VO_SW_AREAS_USE_SWMGR ?= false;
variable VO_SW_AREAS ?= WN_AREA;


# Area to use for VO accounts home directories
# This is an dict where the keys are the VO names (as in the VOS variable)
# and the value is a base directory name. Actual home directory for an account
# will be suffixed by the role account suffix or by the pool account number
#
# Directory parent for accounts may contain the following values: @VONAME@ and
# @VOALIAS@ which will respectively be expanded to the VO full name or the
# VO alias.
#
# This variable is ignored for VO software manager if there is an entry for the
# VO in VO_SWMGR_HOMES.
#
# Example : use /home/voname for all VOs except ALICE and Atlas
# variable VO_HOMES ?= dict("DEFAULT", "/home/@VONAME@",
#                            "alice", "/home2/@VONAME@",
#                            "atlas", "/home3",
#);
#

variable VO_HOMES ?= undef;

# Relocate home directory of VO accounts to a dedicated NFS mount point if
# under /home. This allows to keep /home as the default root for home directories
# but to avoid mounting /home as a NFS system for all accounts, including service
# accounts. This is ignored on a machine where NFS_SERVER_ENABLED is false.
# Default is not to relocate for backward compatibility but this is strongly
# advise to define it.
#
variable VO_HOMES_NFS_ROOT ?= undef;

# Area to use for VO software manager home directory.
# This is an dict where the keys are the VO names (as in the VOS variable)
# and the value is a actual directory name.
#
# When there is no entry for a VO, VO_HOMES is used. The main purpose of this
# variable is to define SW manager home directory to VO software area. To
# achieve this, just assign VO_SW_AREAS to VO_SWMGR_HOMES
#
# For example :
# variable VO_SWMGRS_HOMES ?= VO_SW_AREAS;
#



# USER INTERFACE DEFINITIONS ------------------------------------------------
# ---------------------------------------------------------------------------

# MyProxy server :
# MY_PROXY_SERVER is a legacy name, use it if defined.
# If not default defined and a PX is configured locally, use it as the default PX server.
variable MY_PROXY_SERVER ?= undef;
variable MYPROXY_DEFAULT_SERVER ?= MY_PROXY_SERVER;
variable MYPROXY_DEFAULT_SERVER ?= PX_HOST;


# MPI SUPPORT ---------------------------------------------------------------
# ---------------------------------------------------------------------------

# Disable by default
variable ENABLE_MPI ?= false;


# MatLab SUPPORT ------------------------------------------------------------
# ---------------------------------------------------------------------------

# This variable lists the MatLab installed versions
variable MATLAB_INSTALL_DIR ?= undef;

# Add a SW tag for all the installed version, except DEFAULT as we
# don't know what version it is.
variable CE_RUNTIMEENV = {
    ce_runtimeenv = SELF;
    if (is_dict(MATLAB_INSTALL_DIR)) {
        foreach (version_e;path;MATLAB_INSTALL_DIR) {
            if (version_e != 'DEFAULT') {
                tag = 'MATLAB_' + to_uppercase(unescape(version_e));
                if (index(tag, SELF) < 0) {
                    ce_runtimeenv = append(tag);
                };
            };
        };
    };
    ce_runtimeenv;
};



# APEL SUPPORT --------------------------------------------------------------
# ---------------------------------------------------------------------------

# The following variables have default values defined in APEL-related templates.
# They are listed here just for reference.
#variable APEL_ENABLED ?= true;
#variable APEL_DB_NAME ?= 'accounting';
#variable APEL_DB_USER ?= 'accounting';
#variable APEL_DB_PWD ?= undef;


# FTS SUPPORT ---------------------------------------------------------------
# ---------------------------------------------------------------------------

variable FTS_SERVER_HOST ?= undef;
variable FTS_SERVER_PORT ?= 8443;
variable FTS_SERVER_TRANSFER_SERVICE_PATH ?= '/glite-data-transfer-fts';


# WORKER NODE DEFINITIONS  --------------------------------------------------
# ---------------------------------------------------------------------------

# WORKER_NODES must contain a list of fully qualified host names of all of the WNs
# on the CE.
# From this list, a dict is built to ease some configuration operations.

variable WORKER_NODES ?= undef;
variable WORKER_NODES_DICT = {
    if (exists(WORKER_NODES) && is_defined(WORKER_NODES) && (length(WORKER_NODES) > 0)) {
        foreach (i;wn;WORKER_NODES) {
            SELF[wn] = '';
        };
        SELF;
    } else {
        undef;
    };
};


# Define number of process slots per CPU.
# Should be 2 to accomodate MAUI SRs if using LAL configuration
# variable WN_CPU_SLOTS = 2;


# Define the number of CPU per machine.
# WN_CPUS_DEF defines default value, WN_CPUS lists exceptions
# If the following variables are undefined, WN_CPU_CONFIG will be used.
variable WN_CPUS_DEF ?= 1;     # Assume any CPU as at least one core...
#variable WN_CPUS = dict(
#  "grid15."+SITE_DOMAIN, 2,
#  "grid16."+SITE_DOMAIN, 2,
#);


# Define specific attributes for all or some of the worker nodes
# To define an attribute that apply to each WN, use special entry DEFAULT.
# This can be used to force all nodes to drain.
# Each entry value must be a dict.
#variable WN_ATTRS = dict(
#  "DEFAULT",    dict("state", "offline"),
#);

# On the CE, get information about CPU/core configuration of each WN.
# Used in particular for computing PhysicalCPUs/LogicalCPUs published into BDII.
# If an explicit number of cores have been defined in WN_CPUS, use it
# instead of the number configured in HW description.
variable WN_CPU_CONFIG = {
    if (!is_defined(CE_HOSTS)) {
        return(undef);
    };
    if ((index(FULL_HOSTNAME, CE_HOSTS) < 0) && (FULL_HOSTNAME != LRMS_SERVER_HOST)) {
        return(undef);
    };

    foreach (i;wn;WORKER_NODES) {
        if (exists(DB_MACHINE[escape(wn)])) {
            wn_hw = create(DB_MACHINE[escape(wn)]);
        } else {
            error(wn + ": hardware not found in machine database");
        };
        cpu_num = length(wn_hw['cpu']);
        core_num = 0;
        slot_num = 0;
        if (cpu_num > 0) {
            if (is_defined(WN_CPUS[wn])) {
                core_num = WN_CPUS[wn];
                slot_num = core_num;
            } else if (is_defined(wn_hw['cpu'][0]['cores'])) {
                core_num = cpu_num * wn_hw['cpu'][0]['cores'];
                slot_num = core_num;

                # Take SMT into account when calculating slots
                if (is_defined(wn_hw['cpu'][0]['max_threads']) && wn_hw['cpu'][0]['max_threads']) {
                    # TODO: Only apply this if SMT is enabled system-wide
                    slot_num = cpu_num * wn_hw['cpu'][0]['max_threads'];
                } else if (is_defined(wn_hw['cpu'][0]['hyperthreading']) && wn_hw['cpu'][0]['hyperthreading']) {
                    slot_num = slot_num * 2;
                };
            } else {
                core_num = WN_CPUS_DEF;
                slot_num = core_num;
            };
        };
        SELF[wn] = dict(
            'cpus', cpu_num,
            'cores', core_num,
            'slots', slot_num,
);
    };

    debug('WN_CPU_CONFIG='+to_string(SELF));
    SELF;
};
