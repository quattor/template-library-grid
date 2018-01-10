unique template personality/ui/config;

variable X509_USER_PROXY_PATH ?= if ( is_null(SELF) ) {
                                   SELF;
                                 } else {
                                   '/tmp/x509up_u`id -u`';
                                 };

#-----------------------------------------------------------------------------
# Define need variable for glite-wms-command
#-----------------------------------------------------------------------------

'/software/components/profile/env' = {
  if ( is_defined(X509_USER_PROXY_PATH) ) {
    SELF['X509_USER_PROXY'] = X509_USER_PROXY_PATH;
  };
  SELF;
};
