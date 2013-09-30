unique template glite/ui/rpms/sl5/x86_64/config;

# SAGA implementation install everything under /usr/local and this may be a problem
# at some sites where /usr/local is not a local file system...
variable UI_INSTALL_SAGA ?= false;

# Install Xrootd client
variable XROOT_CLIENT_ENABLED ?= true;

# EMI UI
'/software/packages' = pkg_repl('emi-ui',     '3.0.0-1.el5','x86_64');
'/software/packages' = pkg_repl('emi-version','3.0.0-1.sl5','x86_64');


# CGSI
"/software/packages"=pkg_repl("CGSI-gSOAP","1.3.5-2.el5","x86_64");
"/software/packages"=pkg_repl("CGSI-gSOAP","1.3.5-2.el5","i386");
"/software/packages"=pkg_repl("gsoap","2.7.13-3.el5","x86_64");

##############
# DPM Client #
##############
'/software/packages' = pkg_repl('dpm',         '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('dpm-libs',    '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('dpm-devel',   '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lcgdm-libs',  '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lcgdm-devel', '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('dpm-perl',    '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('dpm-python',  '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('dpm-python26','1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('dpm-libs',    '1.8.6-1.el5', 'i386');
'/software/packages' = pkg_repl('lcgdm-libs',  '1.8.6-1.el5', 'i386');
'/software/packages' = pkg_repl('lcgdm-devel', '1.8.6-1.el5', 'i386');

##############
# LFC Client #
##############
'/software/packages' = pkg_repl('lfc',         '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lfc-libs',    '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lfc-devel',   '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lfc-perl',    '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lfc-python',  '1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lfc-python26','1.8.6-1.el5', 'x86_64');
'/software/packages' = pkg_repl('lfc-libs',    '1.8.6-1.el5', 'i386');

########
# GFal #
########
'/software/packages' = pkg_repl('gfal',         '1.14.0-1.el5','x86_64');
'/software/packages' = pkg_repl('gfal',         '1.14.0-1.el5','i386');
'/software/packages' = pkg_repl('gfal-doc',     '1.14.0-1.el5','x86_64');
'/software/packages' = pkg_repl('gfal-python',  '1.14.0-1.el5','x86_64');
'/software/packages' = pkg_repl('gfal-python26','1.14.0-1.el5','x86_64');

'/software/packages' = pkg_repl('gfal2-all',           '2.1.0-2.el5','x86_64');
'/software/packages' = pkg_repl('gfal2-python',        '1.1.0-0.el5',      'x86_64');
'/software/packages' = pkg_repl('gfal2-core',          '2.1.0-2.el5','x86_64');
'/software/packages' = pkg_repl('gfal2-plugin-dcap',   '2.1.0-2.el5','x86_64');
'/software/packages' = pkg_repl('gfal2-plugin-gridftp','2.1.0-2.el5','x86_64');
'/software/packages' = pkg_repl('gfal2-plugin-lfc',    '2.1.0-2.el5','x86_64');
'/software/packages' = pkg_repl('gfal2-plugin-rfio',   '2.1.0-2.el5','x86_64');
'/software/packages' = pkg_repl('gfal2-plugin-srm',    '2.1.0-2.el5','x86_64');
'/software/packages' = pkg_repl('gfal2-transfer',      '2.1.0-2.el5','x86_64');

'/software/packages' = pkg_repl('gfalFS','1.0.1-0.el5','x86_64');

#################
# dCache Client #
#################
'/software/packages' = pkg_repl('dcache-srmclient', '2.2.4-2.el5', 'x86_64');

################
# Storm Client #
################
'/software/packages' = pkg_repl('storm-srm-client','1.6.0-7.el5','x86_64');
'/software/packages' = pkg_repl('emi.amga.amga-cli', '2.4.0-1.sl5', 'x86_64');

###############
# VOMS Client #
###############
'/software/packages' = pkg_repl('voms',         '2.0.10-1.el5','x86_64');
'/software/packages' = pkg_repl('voms',         '2.0.10-1.el5','i386');
'/software/packages' = pkg_repl('voms-clients', '2.0.10-1.el5','x86_64');
'/software/packages' = pkg_repl('voms-api-java','2.0.8-1.el5', "noarch"); #no

#MYPROXY
"/software/packages"=pkg_repl("myproxy","5.5-1.el5","x86_64");
"/software/packages"=pkg_repl("myproxy-libs","5.5-1.el5","x86_64");

#UBERFTP
"/software/packages"=pkg_repl("uberftp","2.4-4.el5","x86_64");

#GLOBUS
#"/software/packages"=pkg_repl("globus-authz","2.2-1.el5","i386");
#"/software/packages"=pkg_repl("globus-authz","2.2-1.el5","i386");
#"/software/packages"=pkg_repl("globus-authz","2.2-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-authz","2.2-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-authz-callout-error","2.2-1.el5","i386");
#"/software/packages"=pkg_repl("globus-authz-callout-error","2.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-callout","2.2-1.el5","i386");
"/software/packages"=pkg_repl("globus-callout","2.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-common","14.7-1.el5","i386");
"/software/packages"=pkg_repl("globus-common","14.7-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-ftp-client","7.4-1.el5","i386");
"/software/packages"=pkg_repl("globus-ftp-client","7.4-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-ftp-control","4.4-1.el5","i386");
"/software/packages"=pkg_repl("globus-ftp-control","4.4-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gass-copy","8.6-1.el5","i386");
"/software/packages"=pkg_repl("globus-gass-copy","8.6-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gass-copy-progs","8.6-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gass-transfer","7.2-1.el5","i386");
"/software/packages"=pkg_repl("globus-gass-transfer","7.2-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gfork","3.2-1.el5","i386");
#"/software/packages"=pkg_repl("globus-gfork","3.2-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gridftp-server","6.5-2.el5","i386");
#"/software/packages"=pkg_repl("globus-gridftp-server","6.5-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gridftp-server-control","2.7-1.el5","i386");
#"/software/packages"=pkg_repl("globus-gridftp-server-control","2.7-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gridftp-server-progs","6.5-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-gridmap-callout-error","1.2-2.el5","i386");
#"/software/packages"=pkg_repl("globus-gridmap-callout-error","1.2-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-callback","4.3-1.el5","i386");
"/software/packages"=pkg_repl("globus-gsi-callback","4.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-cert-utils","8.3-1.el5","i386");
"/software/packages"=pkg_repl("globus-gsi-cert-utils","8.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-credential","5.3-1.el5","i386");
"/software/packages"=pkg_repl("globus-gsi-credential","5.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-openssl-error","2.1-2.el5","i386");
"/software/packages"=pkg_repl("globus-gsi-openssl-error","2.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-core","6.2-1.el5","i386");
"/software/packages"=pkg_repl("globus-gsi-proxy-core","6.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","4.1-2.el5","i386");
"/software/packages"=pkg_repl("globus-gsi-proxy-ssl","4.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gsi-sysconfig","5.3-1.el5","i386");
"/software/packages"=pkg_repl("globus-gsi-sysconfig","5.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-error","4.1-2.el5","i386");
"/software/packages"=pkg_repl("globus-gssapi-error","4.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-gssapi-gsi","10.7-1.el5","i386"); 
"/software/packages"=pkg_repl("globus-gssapi-gsi","10.7-1.el5","x86_64"); 
"/software/packages"=pkg_repl("globus-gss-assist","8.6-1.el5","i386");
"/software/packages"=pkg_repl("globus-gss-assist","8.6-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-io","9.3-1.el5","i386");
"/software/packages"=pkg_repl("globus-io","9.3-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-libtool","1.2-4.el5","x86_64");
#"/software/packages"=pkg_repl("globus-openssl","5.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-openssl-module","3.2-1.el5","i386");
"/software/packages"=pkg_repl("globus-openssl-module","3.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-proxy-utils","5.0-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-rls-client","5.2-6.el5","x86_64");
"/software/packages"=pkg_repl("globus-rsl","9.1-2.el5","x86_64");
#"/software/packages"=pkg_repl("globus-usage","3.1-2.el5","i386");
"/software/packages"=pkg_repl("globus-usage","3.1-2.el5","x86_64");
"/software/packages"=pkg_repl("globus-xio","3.3-1.el5","i386");
"/software/packages"=pkg_repl("globus-xio","3.3-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-xio-gsi-driver","2.3-1.el5","x86_64");
#"/software/packages"=pkg_repl("globus-xio-pipe-driver","2.2-1.el5","x86_64");
"/software/packages"=pkg_repl("globus-xio-popen-driver","2.3-1.el5","x86_64");

##############
# WMS Client #
##############
'/software/packages' = pkg_repl('glite-lb-client',                '6.0.5-1.el5','x86_64');
'/software/packages' = pkg_repl('glite-lbjp-common-trio',         '2.3.8-1.el5','x86_64');
'/software/packages' = pkg_repl('glite-service-discovery-api-c',  '2.2.3-1.sl5','x86_64');
'/software/packages' = pkg_repl('glite-wms-ui-commands',          '3.5.0-3.sl5','x86_64');
'/software/packages' = pkg_repl('glite-wms-ui-api-python',        '3.5.0-3.sl5','x86_64');
'/software/packages' = pkg_repl('glite-wms-utils-exception',      '3.4.1-1.sl5','x86_64');
'/software/packages' = pkg_repl('glite-wms-wmproxy-api-cpp',      '3.5.0-3.sl5','x86_64');
'/software/packages' = pkg_repl('glite-wms-wmproxy-api-python',   '3.4.0-4.sl5','noarch');
'/software/packages' = pkg_repl('glite-wms-wmproxy-api-java',     '3.4.0-4.sl5','noarch');
'/software/packages' = pkg_repl('glite-wms-brokerinfo-access-lib','3.5.0-3.sl5','x86_64');
'/software/packages' = pkg_repl('glite-wms-brokerinfo-access',    '3.5.0-3.sl5','x86_64');
'/software/packages' = pkg_repl('glite-wms-utils-classad',        '3.4.1-1.sl5','x86_64');
'/software/packages' = pkg_repl('glite-lb-client-progs',          '6.0.5-1.el5','x86_64');
'/software/packages' = pkg_repl('glite-lb-common',                '9.0.5-1.el5','x86_64');
'/software/packages' = pkg_repl('glite-lbjp-common-gsoap-plugin', '3.2.7-1.el5','x86_64');
'/software/packages' = pkg_repl('glite-lbjp-common-gss',          '3.2.11-1.el5','x86_64');
'/software/packages' = pkg_repl('glite-jdl-api-cpp',              '3.4.1-2.sl5','x86_64');
'/software/packages' = pkg_repl('glite-jobid-api-c',              '2.2.7-1.el5','x86_64');
'/software/packages' = pkg_repl('SOAPpy', '0.11.6-12.el5', 'noarch');
'/software/packages' = pkg_repl('python-fpconst', '0.7.3-3.el5.1', 'noarch');

########
# dcap #
########
'/software/packages' = pkg_repl('dcap',              '2.47.7-1.el5','x86_64');
'/software/packages' = pkg_repl('dcap-libs',         '2.47.7-1.el5','x86_64');
'/software/packages' = pkg_repl('dcap-devel',        '2.47.7-1.el5','x86_64');
'/software/packages' = pkg_repl('dcap-tunnel-telnet','2.47.7-1.el5','x86_64');
'/software/packages' = pkg_repl('dcap-tunnel-ssl',   '2.47.7-1.el5','x86_64');
'/software/packages' = pkg_repl('dcap-tunnel-krb',   '2.47.7-1.el5','x86_64');
'/software/packages' = pkg_repl('dcap-tunnel-gsi',   '2.47.7-1.el5','x86_64');

##################
# EMI Delegation #
##################
'/software/packages' = pkg_repl('emi-delegation-java','2.2.0-2.sl5','noarch');
'/software/packages' = pkg_repl('delegation-cli',     '2.1.3-1.el5','x86_64');
'/software/packages' = pkg_repl('delegation-api-c',   '2.1.2-7.el5','x86_64');

################
# CREAM Client #
################
'/software/packages' = pkg_repl('glite-ce-cream-client-api-c',  '1.15.1-2.sl5','x86_64');
'/software/packages' = pkg_repl('glite-ce-monitor-client-api-c','1.15.1-2.sl5','x86_64');
'/software/packages' = pkg_repl('glite-ce-cream-cli',           '1.15.1-2.sl5','x86_64');

########
# Yaim #
########
'/software/packages' = pkg_repl('glite-yaim-clients','5.2.0-1.sl5', 'noarch');
'/software/packages' = pkg_repl('glite-yaim-core',   '5.1.1-1.sl5', 'noarch');

############
# Gridsite #
############
'/software/packages' = pkg_repl('gridsite-commands', '2.0.4-1.el5','x86_64');
#'/software/packages' = pkg_repl('gridsite-libs',     '2.0.4-1.el5','i386');
'/software/packages' = pkg_repl('gridsite-libs',     '2.0.4-1.el5','x86_64');

#############
# LCG-info* #
#############
'/software/packages' = pkg_repl('lcg-info',         '1.12.2-1.el5','noarch');
'/software/packages' = pkg_repl('lcg-infosites',    '3.1.0-3.el5', 'noarch');
'/software/packages' = pkg_repl('lcg-tags',         '0.4.0-2',     'noarch');
'/software/packages' = pkg_repl('lcg-util',         '1.14.0-0.el5','x86_64');
'/software/packages' = pkg_repl('lcg-util-libs',    '1.14.0-0.el5','x86_64');
'/software/packages' = pkg_repl('lcg-util-libs',    '1.14.0-0.el5','i386');
'/software/packages' = pkg_repl('lcg-util-python26','1.14.0-0.el5','x86_64');
'/software/packages' = pkg_repl('lcg-util-python',  '1.14.0-0.el5','x86_64');
'/software/packages' = pkg_repl('lcg-ManageVOTag',  '4.0.0-1',     'noarch');


###########
# Unicore #
###########
'/software/packages' = pkg_repl('unicore-hila-emi-es',  '2.3.0-3',    'noarch'); #no
'/software/packages' = pkg_repl('unicore-hila-unicore6','2.4.0-1.sl5',    'noarch');
'/software/packages' = pkg_repl('unicore-hila-shell',   '2.4.0-1.sl5',    'noarch');
'/software/packages' = pkg_repl('unicore-ucc6',         '6.0.0-0.sl5','noarch');

#############
# Nordugrid #
#############
'/software/packages' = pkg_repl('nordugrid-arc',               '3.0.0-1.el5','x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-client',        '3.0.0-1.el5','x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-compat',        '1.0.1-1.el5','x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-java',          '3.0.0-1.el5','x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-plugins-globus','3.0.0-1.el5','x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-plugins-needed','3.0.0-1.el5','x86_64');
'/software/packages' = pkg_repl('nordugrid-arc-python',        '3.0.0-1.el5','x86_64');

# XROOTD
#'/software/packages'=pkg_repl('xrootd-libs','3.0.5-1.el5','i386');
'/software/packages'=pkg_repl('xrootd-libs','3.0.5-1.el5','x86_64');

'/software/packages' =  {
  pkg_repl('emi.saga-adapter.context-cpp','1.0.2-3.sl5','x86_64');
  pkg_repl('emi.saga-adapter.sd-cpp',     '1.0.4-1.sl5','x86_64');
  pkg_repl('emi.saga-adapter.isn-cpp',    '1.0.3-1.sl5','x86_64');
  pkg_repl('emi.saga-adapter.isn-common', '1.0.1-3.sl5','noarch');
  pkg_repl('SAGA.lsu-cpp.engine',         '1.6.0-1.sl5','x86_64');
};

'/software/packages' = pkg_repl('emi-trustmanager',       '3.1.3-1.sl5','noarch');
'/software/packages' = pkg_repl('emi-trustmanager-tomcat','3.0.1-1.sl5','noarch');
'/software/packages' = pkg_repl('emi-trustmanager-axis'  ,'2.0.2-1.sl5','noarch');

'/software/packages' = pkg_repl('gridftp-ifce',           '2.3.0-0.el5',     'x86_64');
'/software/packages' = pkg_repl('gridftp-ifce',           '2.3.0-0.el5',     'i386');
'/software/packages' = pkg_repl('srm-ifce',               '1.14.0-1.el5',    'x86_64');
'/software/packages' = pkg_repl('srm-ifce',               '1.14.0-1.el5',    'i386');
'/software/packages' = pkg_repl('is-interface',           '1.14.0-0.el5',    'x86_64');
'/software/packages' = pkg_repl('is-interface',           '1.14.0-0.el5',    'i386');
'/software/packages' = pkg_repl('transfer-cli',           '4.0.3-1.el5',     'x86_64');
'/software/packages' = pkg_repl('util-c',                 '1.3.2-1_HEAD.el5','x86_64'); #no

#################
# Xrootd client #
#################

include {  if ( XROOT_CLIENT_ENABLED ) 'glite/xrootd/rpms/' +PKG_ARCH_GLITE+'/client' };

##########################
# Provide by third-party #
##########################
'/software/packages' = pkg_repl("editline","2.9-1.sl5",  "x86_64");

###############################
# Additionnal CA meta-package #
###############################
'/software/packages' = pkg_repl('ca_policy_igtf-classic','1.54-1','noarch');
'/software/packages' = pkg_repl('ca_policy_igtf-mics',   '1.54-1','noarch');
'/software/packages' = pkg_repl('ca_policy_igtf-slcs',   '1.54-1','noarch');

############################
# OS specific dependencies #
############################
include { 'config/emi/'+EMI_VERSION+'/ui' };
