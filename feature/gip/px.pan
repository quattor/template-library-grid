unique template feature/gip/px;

variable PX_HOST ?= FULL_HOSTNAME;

# Configure GIP provider for services
include { 'feature/gip/base' };
include { 'components/gip2/config' };
'/software/components/gip2/provider/glite-info-provider-service-myproxy-wrapper' = 
    "#!/bin/sh\n" + 
    "export PATH=/sbin:/bin:/usr/sbin:/usr/bin\n" +
    'export MYPROXY_HOST=' + PX_HOST + "\n" +
    'export MYPROXY_PORT=' + to_string(MYPROXY_PORT) + "\n" +
    'export MYPROXY_CONF=' + MYPROXY_SERVER_CONFIG_FILE + "\n" +
    GIP_PROVIDER_SERVICE + ' ' + GIP_GLUE_TEMPLATES_DIR + '/glite-info-service-myproxy.conf.template ' + SITE_NAME + "\n" +
    GIP_SCRIPTS_DIR + '/glite-info-glue2-simple ' + GIP_GLUE_TEMPLATES_DIR + '/glite-info-glue2-myproxy.conf.template ' + SITE_NAME + "\n";
