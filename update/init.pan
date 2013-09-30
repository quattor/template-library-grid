# This template is included very early in the configuration, as part of
# default gLite parameters definition (defaults/glite/config). It must
# be used only for actions that cannot be posponed at the end of the
# configuration (update/config).

template update/init;

variable EMI_UPDATE_INIT_INCLUDE = if ( is_defined(EMI_UPDATE_VERSION) && (length(EMI_UPDATE_VERSION) > 0) ) { 
                                       if_exists('update/'+EMI_UPDATE_VERSION+'/init');
                                     } else {
                                       null;
                                     };
include { EMI_UPDATE_INIT_INCLUDE };

