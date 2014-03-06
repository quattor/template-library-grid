
unique template feature/globus/base;

# ----------------------------------------------------------------------------
# globuscfg
# ----------------------------------------------------------------------------
include { 'components/globuscfg/config' };

"/software/components/globuscfg/GLOBUS_LOCATION"    = GLOBUS_LOCATION;
"/software/components/globuscfg/globus_flavor_name" = "gcc32dbg";
"/software/components/globuscfg/x509_user_cert"     = SITE_DEF_HOST_CERT;
"/software/components/globuscfg/x509_user_key"      = SITE_DEF_HOST_KEY;
"/software/components/globuscfg/x509_cert_dir"      = SITE_DEF_CERTDIR;
"/software/components/globuscfg/gridmap"            = SITE_DEF_GRIDMAP;
"/software/components/globuscfg/gridmapdir"         = SITE_DEF_GRIDMAPDIR;

# ncm-sysconfig is used to generate sysconfig/globus, if needed
"/software/components/globuscfg/sysconfigUpdate"       = false;

