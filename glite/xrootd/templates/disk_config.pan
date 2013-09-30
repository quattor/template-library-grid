structure template glite/xrootd/templates/disk_config;

'content' = <<EOF;
#>>>>>>>>>>>>> Variable declarations

# Installation specific
set xrdlibdir   = $XRDLIBDIR
#>>>>>>>>>>>>>

all.adminpath /var/spool/xrootd
all.pidpath /var/run/xrootd

xrootd.seclib libXrdSec.so
sec.protocol /usr/$(xrdlibdir) gsi -crl:3 -key:/etc/grid-security/dpmmgr/dpmkey.pem -cert:/etc/grid-security/dpmmgr/dpmcert.pem -md:sha256:sha1 -ca:2 -gmapopt:10 -vomsat:0
sec.protocol /usr/$(xrdlibdir) unix

ofs.authlib libXrdDPMDiskAcc.so.3
ofs.authorize

ofs.osslib libXrdDPMOss.so.3

ofs.trace all
xrd.trace all
oss.trace all

ofs.persist auto hold 0

xrootd.export /

xrd.port 1095
xrd.network nodnr
all.role server

#xrootd.monitor all rbuff 32k auth flush 30s  window 5s dest files info user io redir atl-prod05.slac.stanford.edu:9930
#xrd.report atl-prod05.slac.stanford.edu:9931 every 60s all -buff -poll sync

EOF
