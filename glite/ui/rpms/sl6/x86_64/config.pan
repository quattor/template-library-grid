unique template glite/ui/rpms/sl6/x86_64/config;

# SAGA implementation install everything under /usr/local and this may be a problem
# at some sites where /usr/local is not a local file system...
variable UI_INSTALL_SAGA ?= false;

# Install Xrootd client
variable XROOT_CLIENT_ENABLED ?= true;

# UI - EMI
'/software/packages'=pkg_repl('bouncycastle-mail','1.46-1.sl6','noarch');
'/software/packages'=pkg_repl('canl-c','2.0.9-1.el6','x86_64');
'/software/packages'=pkg_repl('canl-java','1.1.0-2.sl6','noarch');
'/software/packages'=pkg_repl('editline','2.9-1.sl6','x86_64');
'/software/packages'=pkg_repl('emi-ui','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('emi-version','3.0.0-1.sl6','x86_64');

'/software/packages'=pkg_repl('emi.saga-adapter.context-cpp','1.0.2-3.sl6','x86_64');
'/software/packages'=pkg_repl('emi.saga-adapter.isn-common','1.0.1-3.sl6','noarch');
'/software/packages'=pkg_repl('emi.saga-adapter.isn-cpp','1.0.3-1.sl6','x86_64');
'/software/packages'=pkg_repl('emi.saga-adapter.sd-cpp','1.0.4-1.sl6','x86_64');
'/software/packages'=pkg_repl('SAGA.lsu-cpp.engine','1.6.0-1.sl6','x86_64');
'/software/packages'=pkg_repl('fts2-client','2.2.9-1.el6','x86_64');

# EPEL
'/software/packages'=pkg_repl('gridftp-ifce','2.3.1-1.el6','x86_64');
'/software/packages'=pkg_repl('gridftp-ifce','2.3.1-1.el6','i686');
'/software/packages'=pkg_repl('srm-ifce','1.18.0-1.el6','x86_64');
'/software/packages'=pkg_repl('srm-ifce','1.18.0-1.el6','i686');
'/software/packages'=pkg_repl('is-interface','1.15.0-0.el6','x86_64');
'/software/packages'=pkg_repl('is-interface','1.15.0-0.el6','i686');

# CGSI - EPEL
'/software/packages'=pkg_repl('CGSI-gSOAP','1.3.5-2.el6','x86_64');
'/software/packages'=pkg_repl('CGSI-gSOAP','1.3.5-2.el6','i686');
'/software/packages'=pkg_repl('gsoap','2.7.16-3.el6','x86_64');
'/software/packages'=pkg_repl('gsoap','2.7.16-3.el6','i686');

# DPM Client - EPEL 
'/software/packages'=pkg_repl('dpm','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('dpm-devel','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('dpm-libs','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('dpm-libs','1.8.7-3.el6','i686');
'/software/packages'=pkg_repl('dpm-perl','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('dpm-python','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('lcgdm-devel','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('lcgdm-devel','1.8.7-3.el6','i686');
'/software/packages'=pkg_repl('lcgdm-libs','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('lcgdm-libs','1.8.7-3.el6','i686');

# LFC Client - EPEL
'/software/packages'=pkg_repl('lfc','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('lfc-devel','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('lfc-libs','1.8.7-3.el6','i686');
'/software/packages'=pkg_repl('lfc-libs','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('lfc-perl','1.8.7-3.el6','x86_64');
'/software/packages'=pkg_repl('lfc-python','1.8.7-3.el6','x86_64');

# GFal - EPEL 
'/software/packages'=pkg_repl('gfal','1.16.0-1.el6','x86_64');
'/software/packages'=pkg_repl('gfal','1.16.0-1.el6','i686');
'/software/packages'=pkg_repl('gfal-python','1.16.0-1.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-all','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-core','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-devel','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-doc','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-plugin-dcap','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-plugin-gridftp','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-plugin-http','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-plugin-lfc','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-plugin-rfio','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-plugin-srm','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-python','1.2.1-1.el6','x86_64');
'/software/packages'=pkg_repl('gfal2-transfer','2.3.0-0.el6','x86_64');
'/software/packages'=pkg_repl('gfalFS','1.0.1-0.el6','x86_64');

# dCache Client - EMI
'/software/packages'=pkg_repl('dcache-srmclient','2.2.4-2.el6','x86_64');

# Storm Client - EMI
'/software/packages'=pkg_repl('storm-srm-client','1.6.0-7.el6','x86_64');
'/software/packages'=pkg_repl('emi.amga.amga-cli','2.4.0-1.sl6','x86_64');

# VOMS Client - EMI
'/software/packages'=pkg_repl('voms','2.0.10-1.el6','x86_64');
'/software/packages'=pkg_repl('voms','2.0.10-1.el6','i686');
'/software/packages'=pkg_repl('voms-api-java3','3.0.0-1.el6','noarch');
'/software/packages'=pkg_repl('voms-clients3','3.0.0-1.el6','noarch');

# MYPROXY - EPEL
'/software/packages'=pkg_repl('myproxy','5.9-2.el6','x86_64');
'/software/packages'=pkg_repl('myproxy-libs','5.9-2.el6','x86_64');

# UBERFTP - EPEL
'/software/packages'=pkg_repl('uberftp','2.6-4.el6','x86_64');

# GLOBUS - EPEL
'/software/packages'=pkg_repl('globus-callout','2.2-1.el6','i686');
'/software/packages'=pkg_repl('globus-callout','2.2-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-common','14.9-1.el6','i686');
'/software/packages'=pkg_repl('globus-common','14.9-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-common-progs','14.9-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-ftp-client','7.4-1.el6','i686');
'/software/packages'=pkg_repl('globus-ftp-client','7.4-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-ftp-control','4.5-2.el6','i686');
'/software/packages'=pkg_repl('globus-ftp-control','4.5-2.el6','x86_64');
'/software/packages'=pkg_repl('globus-gass-copy','8.6-1.el6','i686');
'/software/packages'=pkg_repl('globus-gass-copy','8.6-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gass-copy-progs','8.6-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gass-transfer','7.2-1.el6','i686');
'/software/packages'=pkg_repl('globus-gass-transfer','7.2-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-callback','4.4-1.el6','i686');
'/software/packages'=pkg_repl('globus-gsi-callback','4.4-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-cert-utils','8.3-1.el6','i686');
'/software/packages'=pkg_repl('globus-gsi-cert-utils','8.3-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-cert-utils-progs','8.3-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-credential','5.3-1.el6','i686');
'/software/packages'=pkg_repl('globus-gsi-credential','5.3-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-openssl-error','2.1-2.el6','i686');
'/software/packages'=pkg_repl('globus-gsi-openssl-error','2.1-2.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-proxy-core','6.2-1.el6','i686');
'/software/packages'=pkg_repl('globus-gsi-proxy-core','6.2-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-proxy-ssl','4.1-2.el6','i686');
'/software/packages'=pkg_repl('globus-gsi-proxy-ssl','4.1-2.el6','x86_64');
'/software/packages'=pkg_repl('globus-gsi-sysconfig','5.3-1.el6','i686');
'/software/packages'=pkg_repl('globus-gsi-sysconfig','5.3-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gss-assist','8.7-1.el6','i686');
'/software/packages'=pkg_repl('globus-gss-assist','8.7-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-gssapi-error','4.1-2.el6','i686');
'/software/packages'=pkg_repl('globus-gssapi-error','4.1-2.el6','x86_64');
'/software/packages'=pkg_repl('globus-gssapi-gsi','10.7-1.el6','i686');
'/software/packages'=pkg_repl('globus-gssapi-gsi','10.7-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-io','9.4-1.el6','i686');
'/software/packages'=pkg_repl('globus-io','9.4-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-openssl-module','3.2-1.el6','i686');
'/software/packages'=pkg_repl('globus-openssl-module','3.2-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-proxy-utils','5.0-6.el6','x86_64');
'/software/packages'=pkg_repl('globus-usage','3.1-2.el6','x86_64');
'/software/packages'=pkg_repl('globus-xio','3.3-1.el6','i686');
'/software/packages'=pkg_repl('globus-xio','3.3-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-xio-gsi-driver','2.3-1.el6','i686');
'/software/packages'=pkg_repl('globus-xio-gsi-driver','2.3-1.el6','x86_64');
'/software/packages'=pkg_repl('globus-xio-popen-driver','2.3-1.el6','i686');
'/software/packages'=pkg_repl('globus-xio-popen-driver','2.3-1.el6','x86_64');

# WMS Client - EMI
'/software/packages'=pkg_repl('glite-lb-client','6.0.5-1.el6','x86_64');
'/software/packages'=pkg_repl('glite-lb-client-progs','6.0.5-1.el6','x86_64');
'/software/packages'=pkg_repl('glite-lb-common','9.0.5-1.el6','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-gsoap-plugin','3.2.7-1.el6','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-gss','3.2.11-1.el6','x86_64');
'/software/packages'=pkg_repl('glite-lbjp-common-trio','2.3.8-1.el6','x86_64');
'/software/packages'=pkg_repl('glite-service-discovery-api-c','2.2.3-1.sl6','x86_64');
'/software/packages'=pkg_repl('glite-wms-brokerinfo-access','3.5.0-3.sl6','x86_64');
'/software/packages'=pkg_repl('glite-wms-brokerinfo-access-lib','3.5.0-3.sl6','x86_64');
'/software/packages'=pkg_repl('glite-wms-ui-api-python','3.5.0-3.sl6','x86_64');
'/software/packages'=pkg_repl('glite-wms-ui-commands','3.5.0-3.sl6','x86_64');
'/software/packages'=pkg_repl('glite-wms-utils-classad','3.4.1-1.sl6','x86_64');
'/software/packages'=pkg_repl('glite-wms-utils-exception','3.4.1-1.sl6','x86_64');
'/software/packages'=pkg_repl('glite-wms-wmproxy-api-cpp','3.5.0-3.sl6','x86_64');
'/software/packages'=pkg_repl('glite-jdl-api-cpp','3.4.1-2.sl6','x86_64');
'/software/packages'=pkg_repl('glite-jobid-api-c','2.2.7-1.el6','x86_64');

# dcap - EPEL 
'/software/packages'=pkg_repl('dcap','2.47.8-1.el6','x86_64');
'/software/packages'=pkg_repl('dcap-devel','2.47.8-1.el6','x86_64');
'/software/packages'=pkg_repl('dcap-libs','2.47.8-1.el6','x86_64');
'/software/packages'=pkg_repl('dcap-libs','2.47.8-1.el6','i686');
'/software/packages'=pkg_repl('dcap-tunnel-gsi','2.47.8-1.el6','x86_64');
'/software/packages'=pkg_repl('dcap-tunnel-krb','2.47.8-1.el6','x86_64');
'/software/packages'=pkg_repl('dcap-tunnel-ssl','2.47.8-1.el6','x86_64');
'/software/packages'=pkg_repl('dcap-tunnel-telnet','2.47.8-1.el6','x86_64');

# CREAM Client - EMI 
'/software/packages'=pkg_repl('glite-ce-cream-cli','1.15.1-2.sl6','x86_64');
'/software/packages'=pkg_repl('glite-ce-cream-client-api-c','1.15.1-2.sl6','x86_64');
'/software/packages'=pkg_repl('glite-ce-monitor-cli','1.15.1-2.sl6','x86_64');
'/software/packages'=pkg_repl('glite-ce-monitor-client-api-c','1.15.1-2.sl6','x86_64');

# Yaim - EMI
'/software/packages'=pkg_repl('glite-yaim-clients','5.2.0-1.sl6','noarch');
'/software/packages'=pkg_repl('glite-yaim-core','5.1.1-1.sl6','noarch');

# Gridsite - EMI
'/software/packages'=pkg_repl('gridsite-commands','2.0.4-1.el6','x86_64');
'/software/packages'=pkg_repl('gridsite-libs','2.0.4-1.el6','x86_64');
'/software/packages'=pkg_repl('gridsite1.7-compat','1.7.25-2','x86_64'); # EPEL

# LCG-info - EMI
'/software/packages'=pkg_repl('lcg-ManageVOTag','4.0.0-1','noarch');
'/software/packages'=pkg_repl('lcg-info','1.12.2-1.el6','noarch');
'/software/packages'=pkg_repl('lcg-infosites','3.1.0-3.el6','noarch');
'/software/packages'=pkg_repl('lcg-tags','0.4.0-2','noarch');

# LCG - EPEL
'/software/packages'=pkg_repl('lcg-util','1.16.0-2.el6','x86_64');
'/software/packages'=pkg_repl('lcg-util-libs','1.16.0-2.el6','x86_64');
'/software/packages'=pkg_repl('lcg-util-libs','1.16.0-2.el6','i686');
'/software/packages'=pkg_repl('lcg-util-python','1.16.0-2.el6','x86_64');

# Unicore - EMI
'/software/packages'=pkg_repl('unicore-hila-emi-es','2.4.0-1.sl6','noarch');
'/software/packages'=pkg_repl('unicore-hila-gridftp','2.4.0-1.sl6','noarch');
'/software/packages'=pkg_repl('unicore-hila-shell','2.4.0-1.sl6','noarch');
'/software/packages'=pkg_repl('unicore-hila-unicore6','2.4.0-1.sl6','noarch');
'/software/packages'=pkg_repl('unicore-ucc6','6.0.0-0.sl6','noarch');

# Nordugrid - EMI 
'/software/packages'=pkg_repl('nordugrid-arc','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('nordugrid-arc-client','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('nordugrid-arc-client-tools','1.0.6-1.el6','noarch');
'/software/packages'=pkg_repl('nordugrid-arc-java','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('nordugrid-arc-plugins-gfal','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('nordugrid-arc-plugins-globus','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('nordugrid-arc-plugins-needed','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('nordugrid-arc-plugins-xrootd','3.0.0-1.el6','x86_64');
'/software/packages'=pkg_repl('nordugrid-arc-python','3.0.0-1.el6','x86_64');

# XRootD
include {  if ( XROOT_CLIENT_ENABLED ) 'glite/xrootd/rpms/' +PKG_ARCH_GLITE+'/client' };

include { 'config/emi/'+EMI_VERSION+'/ui' };
