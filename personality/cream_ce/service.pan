# Template defining all the MW components required for a CREAM CE
# Include Torque/MAUI server if used as LRMS

unique template personality/cream_ce/service;

variable CE_FLAVOR = 'cream';

variable GLITE_LOCATION = '/usr';
variable MKGRIDMAP_BIN ?= '/usr/sbin/';


# Fully qualified name of CEMon host
variable CEMON_HOST ?= CE_HOST;
variable CEMON_PORT ?= 8443;

# Fully qualified name of machine hosting the BLAH blparser.
# This variable must be defined BEFORE batch system configuration.
# The BLparser must be installed on a machine where the batch system log files are available.
variable BLPARSER_HOST ?= LRMS_SERVER_HOST;

# Directory used for storing sandboxes.
# CREAM_SANDBOX_DIRS if defined allows to specify a different sandbox dir for each CE configured.
# When wanting to get sandbox sharing through NFS configured by Quattor, CREAM_SANDBOX_DIRS definition
# is mandatory.
variable CREAM_SANDBOX_DIRS ?= dict();
variable CREAM_SANDBOX_DIR ?= {
    if ( is_defined(CREAM_SANDBOX_DIRS[CE_HOST]) ) {
        CREAM_SANDBOX_DIRS[CE_HOST];
    } else if ( is_defined(CREAM_SANDBOX_DIRS['DEFAULT']) ) {
        CREAM_SANDBOX_DIRS['DEFAULT'];
    } else {
        '/var/cream_sandbox';
    };
};

# Include CREAM CE RPMs
include 'personality/cream_ce/rpms/config';

# Add glite user/group, set permissions on key directories and add BDII_USER to glite group
include 'users/glite';
include 'features/grid/dirperms';

# Configure resource BDII.
include 'personality/bdii/service';

# Configure classads library
include 'features/classads/config';

# Add MySQL server.
include 'features/mysql/server';

# Configure LRMS if one specified and LRMS server is running on the CE.
# When using MAUI, postpone configuration of maui-monitoring after GIP configuration.
variable MAUI_MONITORING_POSTPONED = true;
variable LRMS_SERVER_INCLUDE = {
    if (is_defined(CE_BATCH_NAME)) {
        if (CE_BATCH_NAME == 'condor') {
            batch_dir = 'htcondor';
        } else {
            batch_dir = CE_BATCH_NAME;
        };

        if ( LRMS_SERVER_HOST == FULL_HOSTNAME ) {
            "features/" + batch_dir + "/server/service";
        } else {
            client_include = if_exists("features/" + batch_dir + "/client/client-only");
            if ( is_defined(client_include) ) {
                client_include;
            } else {
                "features/" + batch_dir + "/client/service"
            };
        };
    } else {
        null;
    };
};
include LRMS_SERVER_INCLUDE;

# Also build queue names (required by CE GIP configuration) if not done as part of the client configuration
include if ( LRMS_SERVER_HOST != FULL_HOSTNAME ) if_exists("features/" + CE_BATCH_NAME + "/server/build-queue-list");


# Ensure that the host certificates have the correct permissions.
include 'features/security/host_certs';

# Modify the loadable library path.
include 'features/ldconf/config';

# LCG and Globus sysconfig and environment variables
include 'features/globus/sysconfig';
include 'features/edg/sysconfig';

# Add accepted CAs
include 'security/cas';

# Update the certificate revocation lists.
include 'features/fetch-crl/config';

# Authorization via grid mapfile.
include 'features/mkgridmap/standard';

# MPI-CH configuration.
include 'features/mpi/config';

# Configure java.
include 'features/java/config';

# Configuration for LCMAPS.
include 'features/lcmaps/base';

# Configuration for LCAS.
include 'features/lcas/base';

# Configure Tomcat.
include 'features/tomcat/config';

# Configure lb-locallogger
include 'features/lb/locallogger';

# CREAM CE specific tasks
include 'personality/cream_ce/config';

# Configure the information provider.
# Do it after configuring BDII to avoid creation of unneeded edginfo account
variable CE_GIP_INCLUDE = {
    if ( exists(CE_BATCH_SYS) && is_defined(CE_BATCH_SYS) && match(CE_BATCH_SYS, 'condor|lsf|lcgpbs|pbs|torque') ) {
        'features/gip/ce';
    } else {
        null;
    };
};

include 'features/gip/base';
include CE_GIP_INCLUDE;

# PBS accounting.
variable APEL_ACCOUNTING_CONFIG ?= {
    if (match(CE_BATCH_SYS, 'condor')) {
        'features/accounting/apel/parser_condor';
    }else{
        'features/accounting/apel/parser_blah';
    }
};

include APEL_ACCOUNTING_CONFIG;

# Configure gridftp server
# Must be done after configuring GIP provider
include 'features/gridftp/service';


# ----------------------------------------------------------------------------
# Configure NFS mount points for CREAM CE sandbox directory if requested.
# NFS sharing of CREAM CE sandbox directory is enabled with variable
# CREAM_SANDBOX_MPOINTS which can contain one entry per CE host sharing its
# sandbox directory with WNs.
# Sharing is disabled if variable CREAM_SANDBOX_SHARED_FS is defined with a
# value different than 'nfs[34]'.
# ----------------------------------------------------------------------------
include 'features/nfs/cream-sandbox';


# Configure MAUI monitoring, also used to optionally implement a GIP plugin cache.
include if ( exists(MAUI_MONITORING_TEMPLATE) ) MAUI_MONITORING_TEMPLATE;

