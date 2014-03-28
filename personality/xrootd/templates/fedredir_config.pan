structure template personality/xrootd/templates/fedredir_config;

'content' = <<EOF;
#>>>>>>>>>>>>> Variable declarations

# Installation specific
set xrootfedxrdmanager = $XROOT_FED_REMOTE_XRD_MANAGER_ATLAS
set xrootfedcmsdmanager = $XROOT_FED_REMOTE_CMSD_MANAGER_ATLAS
set xrootfedlport = $XROOT_FED_LOCAL_PORT_ATLAS
set xrdlibdir = $XRDLIBDIR

#>>>>>>>>>>>>>

all.adminpath /var/spool/xrootd
all.pidpath /var/run/xrootd
all.export /atlas/

xrd.network nodnr

pss.trace all
ofs.trace all
xrd.trace all
cms.trace all
oss.trace all

if exec xrootd
xrootd.seclib libXrdSec.so
sec.protocol /usr/$(xrdlibdir) gsi -crl:3 -key:/etc/grid-security/dpmmgr/dpmkey.pem -cert:/etc/grid-security/dpmmgr/dpmcert.pem -md:sha256:sha1 -ca:2 -gmapopt:10 -vomsat:0
sec.protocol /usr/$(xrdlibdir) unix

ofs.cmslib libXrdDPMFinder.so.3
ofs.osslib libXrdDPMOss.so.3

ofs.authlib libXrdDPMRedirAcc.so.3
ofs.authorize

# access may be restricted by vo; but this option is only
# useful if voms attribute processing is enabled
# dpm.allowvo atlas

# use a namelib for more complex transformations
#
setenv LFC_HOST=the_lfc.example.com
setenv GLOBUS_THREAD_MODEL=pthread
setenv X509_USER_PROXY=/the/path/my_atlas_proxy
dpm.namelib XrdOucName2NameLFC.so root=/dpm/example.com/home/atlas match=svr001.example.com
dpm.namecheck /dpm/example.com/home/atlas
#
# or for simple prefix check/additions or substitutions
#
# dpm.replacementprefix /atlas /dpm/example.com/home/myatlas
# dpm.defaultprefix /dpm/example.com/home

dpm.xrdserverport 1095

xrd.port $(xrootfedlport)
xrootd.redirect $(xrootfedxrdmanager) ? /atlas/
all.role manager
ofs.forward all
dpm.enablecmsclient

#xrd.report atl-prod05.slac.stanford.edu:9931 every 60s all -buff -poll sync
fi

if exec cmsd
all.role server
ofs.osslib libXrdPss.so
pss.origin localhost:$(xrootfedlport)
all.manager $(xrootfedcmsdmanager)
fi

#xrootd.monitor all rbuff 32k auth flush 30s  window 5s dest files info user io redir atl-prod05.slac.stanford.edu:9930

EOF
