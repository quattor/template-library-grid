structure template glite/xrootd/templates/redir_config;

'content' = <<EOF;
#>>>>>>>>>>>>> Variable declarations

# Installation specific
set xrdlibdir = $XRDLIBDIR
# set dpmhost = grid05.lal.in2p3.fr
# set xrootfedlport1 = $XROOT_FED_LOCAL_PORT_ATLAS
# set xrootfedlport2...
# setenv DPNS_HOST = $dpmhost
# setenv DPM_HOST = $dpmhost

#>>>>>>>>>>>>>

all.adminpath /var/spool/xrootd
all.pidpath /var/run/xrootd

xrd.network nodnr
xrootd.seclib libXrdSec.so
sec.protocol /usr/$(xrdlibdir) gsi -crl:3 -key:/etc/grid-security/dpmmgr/dpmkey.pem -cert:/etc/grid-security/dpmmgr/dpmcert.pem -md:sha256:sha1 -ca:2 -gmapopt:10 -vomsat:0
sec.protocol /usr/$(xrdlibdir) unix

ofs.cmslib libXrdDPMFinder.so.3
ofs.osslib libXrdDPMOss.so.3
ofs.authorize
ofs.forward all

dpm.xrdserverport 1095

# for any federations setup provide a reirect to federation handler
#xrootd.redirect $dpmhost:11001 /store/
#xrootd.redirect $dpmhost:11000 /atlas/

# the following can be used to check for and if necessary add a
# prefix to file names. i.e. to allow access via names like /dteam/the_file
#dpm.defaultprefix /dpm/lal.in2p3.fr/home

ofs.trace all
xrd.trace all
cms.trace all
oss.trace all

xrootd.export /

all.role manager

# authorization; by default authorization is only up to the dpm
#
ofs.authlib libXrdDPMRedirAcc.so.3
#
# more advanced: the "secondary" authlib (if set) is an xrootd
# authorization library given as the argument to libXrdDPMRedirAcc.
# It is used as follows:
#
#   If no usable identity is available via the "sec.protocol" or if
# special tokens are found in the opaque data, a secondary authlib can
# be used to check and allow requests to be sent to the dpm on behalf
# of a fixed identity, set here.
#
# e.g. libXrdAliceTokenAcc
#
# setenv TTOKENAUTHZ_AUTHORIZATIONFILE=/etc/xrd.authz.cnf
ofs.authlib libXrdDPMRedirAcc.so.3
# dpm.replacementprefix /alice /dpm/example.com/home/alice
# dpm.fixedidrestrict /dpm/example.com/home/alice
#
# User must be listed in lcgdm-mapfile
# dpm.principal alicetoken
# dpm.fqan /alice

#xrootd.monitor all rbuff 32k auth flush 30s  window 5s dest files info user io redir atl-prod05.slac.stanford.edu:9930
#xrd.report atl-prod05.slac.stanford.edu:9931 every 60s all -buff -poll sync

EOF
