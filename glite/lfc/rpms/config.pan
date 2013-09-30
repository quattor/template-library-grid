unique template glite/lfc/rpms/config;


# RPMs common to all LFC flavors
include  { 'glite/lfc/rpms/' + PKG_ARCH_GLITE + '/base' };


# RPMs specific to LFC flavor used on the current node
variable LFC_SERVER_FLAVOUR = if ( LFC_SERVER_MYSQL ) {
                                return('glite/lfc/rpms/'+PKG_ARCH_GLITE+'/mysql');
                              } else {
                                return('glite/lfc/rpms/'+PKG_ARCH_GLITE+'/oracle');
                              };
include { LFC_SERVER_FLAVOUR };

