unique template glite/voms/rpms/config;

# RPMS common to all VOMS variants
include  { 'glite/voms/rpms/' + PKG_ARCH_GLITE + '/base' };

variable VOMS_FLAVOUR_RPMS = if ( (VOMS_DB_TYPE == "mysql") ||  (VOMS_DB_TYPE == "oracle") ) {
                               return("glite/voms/rpms/"+PKG_ARCH_GLITE+"/"+VOMS_DB_TYPE);
                             } else {
                               error ("Unsupported VOMS database type ("+VOMS_DB_TYPE+")");
                             };
include { VOMS_FLAVOUR_RPMS };
