unique template features/gip/lb;

variable GIP_PROVIDER_SERVICE_TYPE_LB ?= 'org.glite.lb.Server';
variable GIP_PROVIDER_SERVICE_INIT_LB ?= GIP_SCRIPTS_DIR + '/glite-info-service-lbserver';
variable GIP_PROVIDER_SERVICE_CONF_LB ?= GIP_BASE_DIR + '/glite-info-service-lbserver.conf';
variable GIP_PROVIDER_SERVICE_UNIQUEID_LB ?= FULL_HOSTNAME+"_"+GIP_PROVIDER_SERVICE_TYPE_LB;
variable GIP_PROVIDER_WRAPPER_LB ?= 'glite-info-service-lbserver';


# Configure GIP provider for services

"/software/components/gip2" = {
    service_owner_cmd = '';
    service_acbr_cmd = '';
    foreach (i;vo;VOS_FULL) {
        service_owner_cmd = service_owner_cmd + ' echo ' + vo + ';';
        service_acbr_cmd = service_acbr_cmd + ' echo VO:' + vo + ';';
    };

    SELF['confFiles'][escape(GIP_PROVIDER_SERVICE_CONF_LB)] =
        "init = "+GIP_PROVIDER_SERVICE_INIT_LB+"\n" +
        "service_type = "+GIP_PROVIDER_SERVICE_TYPE_LB+"\n" +
        "get_version = rpm -qa | grep 'glite-lb-server-[0-9]' | cut -d- -f4\n" +
        "get_endpoint = echo  https://${LBSERVER_HOST}:${LBSERVER_PORT}/\n" +
        "get_status = " + GIP_SCRIPTS_DIR + "/glite-info-service-test LBSERVER && /etc/init.d/glite-lb-bkserverd status\n"+
        "WSDL_URL = echo http://trinity.datamat.it/projects/EGEE/WMProxy/WMProxy.wsdl\n" +
        "semantics_URL = echo https://edms.cern.ch/file/571273/2/LB-guide.pdf\n" +
        "get_starttime =  perl -e '@st=stat($ENV{LBSERVER_PID_FILE});print \"@st[10]\\n\";'\n" +
        "get_owner ="+service_owner_cmd+"\n" +
        "get_acbr ="+service_acbr_cmd+"\n" +
        "get_data =  echo\n" +
        "get_services = echo\n";
    SELF['provider'][GIP_PROVIDER_WRAPPER_LB] =
        "#!/bin/sh\n" +
        GIP_PROVIDER_SERVICE + ' ' + GIP_PROVIDER_SERVICE_CONF_LB + ' ' + SITE_NAME + ' ' +
            GIP_PROVIDER_SERVICE_UNIQUEID_LB + "\n";

    # Glue v2
    SELF['provider'][GIP_PROVIDER_WRAPPER_LB + '-glue2'] =
        "#!/bin/sh\n" +
        GIP_PROVIDER_SERVICE + '-glue2 ' + GIP_PROVIDER_SERVICE_CONF_LB + ' ' + SITE_NAME + ' ' +
            GIP_PROVIDER_SERVICE_UNIQUEID_LB + "\n";

    SELF;
};
