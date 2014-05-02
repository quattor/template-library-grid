unique template features/gip/glite-version;

# ---------------------------------------------------------------------------- 
# gip2
# ---------------------------------------------------------------------------- 
include { 'components/gip2/config' };

variable GIP_PROVIDER_RELEASE ?= GIP_SCRIPTS_DIR + '/glite-info-provider-release';

# Configure GIP provider used to return gLite version of a service.
# This provider is quite specific: it updated the information produced by
# glite-info-provider-service. It requires no specific configuration or arguments.

'/software/components/gip2' = {
    SELF['provider']['glite-info-service-release'] =
        "#!/bin/sh\n" + 
        GIP_PROVIDER_RELEASE + "\n";
    SELF;
};
