unique template common/gip/wms;

variable GIP_PROVIDER_SERVICE_TYPE_WMS ?= 'org.glite.wms.WMProxy';
variable GIP_PROVIDER_SERVICE_INIT_WMS ?= GIP_SCRIPTS_DIR + '/glite-info-service-wmproxy';
variable GIP_PROVIDER_SERVICE_UNIQUEID_WMS ?= FULL_HOSTNAME+"_"+GIP_PROVIDER_SERVICE_TYPE_WMS;
variable GIP_PROVIDER_SERVICE_CONF_WMS ?= GIP_BASE_DIR + '/glite-info-service-wmproxy.conf';
variable GIP_PROVIDER_GLUE2_CONF_WMS ?= GIP_BASE_DIR + '/glite-info-glue2-wmproxy.conf';
variable GIP_PROVIDER_WRAPPER_WMS ?= 'glite-info-service-wmproxy';
variable GIP_PROVIDER_WMPROXY_RPM ?= 'wmproxy';


# Configure GIP provider for services

"/software/components/gip2" = {
    service_owner_cmd = '';
    service_acbr_cmd = '';
    foreach (i;vo;VOS_FULL) {
        service_owner_cmd = service_owner_cmd + ' echo ' + vo + ';';
        service_acbr_cmd = service_acbr_cmd + ' echo VO:' + vo + ';';
    };
  
    SELF['confFiles'][escape(GIP_PROVIDER_SERVICE_CONF_WMS)] = 
        "init = " + GIP_PROVIDER_SERVICE_INIT_WMS + "\n" +
        "service_type = " + GIP_PROVIDER_SERVICE_TYPE_WMS + "\n" +
        "get_version = rpm -q " + GIP_PROVIDER_WMPROXY_RPM + " --queryformat '%{version}\\n'\n" +
        "get_endpoint = echo  https://${WMPROXY_HOST}:${WMPROXY_PORT}/glite_wms_wmproxy_server\n" +
        "get_status = " + GIP_SCRIPTS_DIR + "/glite-info-service-test WMPROXY && " +
            GLITE_LOCATION + "/etc/init.d/glite-wms-wmproxy status\n"+
        "WSDL_URL = echo http://web.infn.it/gLiteWMS/images/WMS/Docs/wmproxy.wsdl\n" +
        "semantics_URL = echo http://web.infn.it/gLiteWMS/images/WMS/Docs/wmproxy-guide.pdf\n" +
        "get_starttime =  perl -e '@st=stat($ENV{WMPROXY_PID_FILE});print \"@st[10]\\n\";'\n" +
        "get_owner = " + service_owner_cmd + "\n" +
        "get_acbr = " + service_acbr_cmd + "\n" +
        "get_data =  echo -n DN= &&  openssl x509 -in " + SITE_DEF_HOST_CERT + " -noout -subject | cut -d = -f 2-\n" +
        "get_services = echo\n";

    SELF['confFiles'][escape(GIP_PROVIDER_GLUE2_CONF_WMS)] =
        "init = " + GIP_PROVIDER_SERVICE_INIT_WMS + "\n" +
        "service_type = " + GIP_PROVIDER_SERVICE_TYPE_WMS + "\n" +
        "get_version = echo 1.0\n" +
        "get_endpoint = echo  https://${WMPROXY_HOST}:${WMPROXY_PORT}/glite_wms_wmproxy_server\n" +
        "get_status = " + GIP_SCRIPTS_DIR + "/glite-info-service-test WMPROXY && " +
            GLITE_LOCATION + "/etc/init.d/glite-wms-wmproxy status\n"+
        "WSDL_URL = echo http://web.infn.it/gLiteWMS/images/WMS/Docs/wmproxy.wsdl\n" +
        "semantics_URL = echo http://web.infn.it/gLiteWMS/images/WMS/Docs/wmproxy-guide.pdf\n" +
        "get_starttime =  perl -e '@st=stat($ENV{WMPROXY_PID_FILE});print \"@st[10]\\n\";'\n" +
        "get_owner = " + service_owner_cmd + "\n" +
        "get_acbr = " + service_acbr_cmd + "\n" +
        "get_data =  echo -n DN= &&  openssl x509 -in " + SITE_DEF_HOST_CERT + " -noout -subject | cut -d = -f 2-\n" +
        "get_capabilities = echo -e \"executionmanagement.candidatesetgenerator\\nexecutionmanagement.jobdescription\\nexecutionmanagement.jobmanager\"\n" +
        "get_implementor = echo gLite" +
        "get_implementationname = echo WMS" +
        "get_implementationversion = rpm -q " + GIP_PROVIDER_WMPROXY_RPM + " --queryformat '%{version}\\n'\n" +
        "get_qualitylevel = echo 4" +
        "get_servingstate = [ -e /etc/glite-wms/.drain ] && echo 2 || echo 4";

    SELF['provider'][GIP_PROVIDER_WRAPPER_WMS] =
        "#!/bin/sh\n" + 
        GIP_PROVIDER_SERVICE + ' ' + GIP_PROVIDER_SERVICE_CONF_WMS + 
            ' ' + SITE_NAME + ' ' + GIP_PROVIDER_SERVICE_UNIQUEID_WMS + "\n";

    # Glue v2
    SELF['provider'][GIP_PROVIDER_WRAPPER_WMS + '-glue2'] =
        "#!/bin/sh\n" + 
        GIP_PROVIDER_SERVICE + '-glue2 ' + GIP_PROVIDER_GLUE2_CONF_WMS + 
            ' ' + SITE_NAME + ' ' + GIP_PROVIDER_SERVICE_UNIQUEID_WMS + "\n";

    SELF;
};


# Configure provider to return gLite version used by the service
include { 'common/gip/glite-version' };
