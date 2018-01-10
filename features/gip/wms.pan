unique template features/gip/wms;

variable GIP_PROVIDER_SERVICE_TYPE_WMS ?= 'org.glite.wms.WMProxy';
variable GIP_PROVIDER_SERVICE_INIT_WMS ?= GIP_SCRIPTS_DIR + '/glite-info-service-wmproxy';
variable GIP_PROVIDER_SERVICE_CONF_WMS ?= GIP_BASE_DIR + '/glite-info-service-wmproxy.conf';
variable GIP_PROVIDER_SERVICE_UNIQUEID_WMS ?= FULL_HOSTNAME+"_"+GIP_PROVIDER_SERVICE_TYPE_WMS;
variable GIP_PROVIDER_WRAPPER_WMS ?= 'glite-info-service-wmproxy';
variable WMPROXY_RPM ?= 'glite-wms-interface';

# Configure GIP provider for services

"/software/components/gip2" = {
    service_owner_cmd = '';
    service_acbr_cmd = '';
    foreach (i;vo;VOS_FULL) {
        service_owner_cmd = service_owner_cmd + ' echo ' + vo + ';';
        service_acbr_cmd = service_acbr_cmd + ' echo VO:' + vo + ';';
    };

    SELF['confFiles'][escape(GIP_PROVIDER_SERVICE_CONF_WMS)] =
        "init = "+GIP_PROVIDER_SERVICE_INIT_WMS+"\n" +
        "service_type = "+GIP_PROVIDER_SERVICE_TYPE_WMS+"\n" +
        "get_version = rpm -q "+ WMPROXY_RPM + " --queryformat '%{version}\\n'\n" +
        "get_endpoint = echo  https://${WMPROXY_HOST}:${WMPROXY_PORT}/glite_wms_wmproxy_server\n" +
        "get_status = " + GIP_SCRIPTS_DIR + "/glite-info-service-test WMPROXY && /etc/init.d/glite-wms-wmproxy status\n"+
        "WSDL_URL = echo http://trinity.datamat.it/projects/EGEE/WMProxy/WMProxy.wsdl\n" +
        "semantics_URL = echo https://edms.cern.ch/file/674643/1/EGEE-JRA1-TEC-674643-WMPROXY-guide-v0-2.pdf\n" +
        "get_starttime =  perl -e '@st=stat($ENV{WMPROXY_PID_FILE});print \"@st[10]\\n\";'\n" +
        "get_owner ="+service_owner_cmd+"\n" +
        "get_acbr ="+service_acbr_cmd+"\n" +
        "get_data =  echo -n DN= && " + GLOBUS_LOCATION + "/bin/grid-cert-info -file " +
            SITE_DEF_HOST_CERT + " -subject\n" +
        "get_services = echo\n";
    SELF['provider'][GIP_PROVIDER_WRAPPER_WMS] =
        "#!/bin/sh\n" +
        GIP_PROVIDER_SERVICE + ' ' + GIP_PROVIDER_SERVICE_CONF_WMS +
            ' ' + SITE_NAME + ' ' + GIP_PROVIDER_SERVICE_UNIQUEID_WMS + "\n";

    # Glue v2
    SELF['provider'][GIP_PROVIDER_WRAPPER_WMS + '-glue2'] =
        "#!/bin/sh\n" +
        GIP_PROVIDER_SERVICE + '-glue2 ' + GIP_PROVIDER_SERVICE_CONF_WMS +
            ' ' + SITE_NAME + ' ' + GIP_PROVIDER_SERVICE_UNIQUEID_WMS + "\n";

    SELF;
};
