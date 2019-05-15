template features/arc-ce/config;

include 'components/chkconfig/config';


'/software/repositories' = append(create('repository/EMI-UMD4_updates_x86_64'));
'/software/repositories' = append(create('repository/nordugrid_centos_el6_x86_64'));
'/software/repositories' = append(create('repository/xrootd/el6-x86_64'));


# GIIS configuration
variable IS_UK_GIIS = (FULL_HOSTNAME == 'arc-ce01.gridpp.rl.ac.uk' || FULL_HOSTNAME == 'arc-ce02.gridpp.rl.ac.uk');

variable GIIS_INDEX = if (IS_UK_GIIS) {
    if (FULL_HOSTNAME == 'arc-ce01.gridpp.rl.ac.uk') 'index1.gridpp.rl.ac.uk'
    else 'index2.gridpp.rl.ac.uk';
}
else {
    '';
};

variable ARC_CONF_GIIS ?= file_contents('features/arc-ce/giis.conf');

# Make sure the appropriate services are running
prefix '/software/components/chkconfig/service';

'gridftpd/on' = '';
'gridftpd/startstop' = true;

'a-rex/on' = '';
'a-rex/startstop' = true;

'nordugrid-arc-ldap-infosys/on' = '';
'nordugrid-arc-ldap-infosys/startstop' = true;

'nordugrid-arc-inforeg/on' = '';
'nordugrid-arc-inforeg/startstop' = true;

## maybe add this to arc-giis feature ?
'nordugrid-arc-egiis' = if (IS_UK_GIIS) dict(
    'on', '',
    'startstop', true,
) else null;

variable VOS ?= list(
    'alice',
    'atlas',
    'cms',
    'lhcb',
    'biomed',
    'geant4',
    'hyperk.org',
    'mice',
    'na62.vo.gridpp.ac.uk',
    'snoplus.snolab.ca',
    'lsst',
    't2k.org',
    'enmr.eu',
    'ilc',
    'pheno',
    'glast.org',
    'gridpp',
    'osg',
    'dteam',
    'ops',
    'skatelescope.eu',
    'dune',
);

variable CONDOR_VERSION ?= '8.6.13-1.el6';
variable CONDOR_ARCH ?= 'x86_64';
variable ARC_VERSION ?= '5.4.3-1.el6';
variable VO_SW_AREAS_USE_SWMGR ?= false;

include 'features/arc-ce/rpms';

include 'features/arc-ce/service';

# Setup required directories
include 'features/arc-ce/setup';

# Access control - LCAS LCMAPS etc.
include 'features/arc-ce/access-control/config';

# vomses and vomsdir (/opt/glite/etc/vomses)
include 'features/arc-ce/vomsdir';

# Plugins
include 'features/arc-ce/plugins/config';

# Local changes
include 'features/arc-ce/changes';

# Delete old archived accounting records
include 'features/arc-ce/cleaning';

# Create files containing number of running & idle jobs by VO
include 'features/arc-ce/jobs';

# Additional log rotations
include 'features/arc-ce/logrotations';

# Replace large files with warning messages
include 'features/arc-ce/largefiles';

# Filebeat
include 'features/arc-ce/filebeat';

# Process history files and forward to accounting database
include 'features/arc-ce/accounting';

# Running fetch-crl every 6 hours (the default) doesn't seem to be enough -
# CRLs have expired twice between fetch-crl runs
include 'features/arc-ce/fetch-crl';

# Configure HTCondor (schedd)
include 'features/arc-ce/condor/config';
