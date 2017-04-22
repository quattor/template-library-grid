# This template installs a cron in charge of producing a proxy for user
# used by GIP or MDS to query DPM about its current configuration (dpm-qryconf)

unique template personality/se_dpm/puppet/info_user_proxy;

variable GIP_USER ?= error('Variable GIP_USER must be configured');
variable SEDPM_INFO_USER ?= GIP_USER;

# ----------------------------------------------------------------------------
# Proxy for resource BDII : a cron entry + a startup script to ensure
# a valid proxy exists at boot time.
# ----------------------------------------------------------------------------
include 'components/cron/config';

# Cron job to create hostproxy for GIP user (used by dynamic plugin)
variable DPM_HOSTPROXY_CRON = SEDPM_INFO_USER + "-hostproxy";
variable DPM_HOSTPROXY_TMP = GLITE_LOCATION_VAR + "/dpm/hostproxy.$$";
variable DPM_HOSTPROXY_FILE = GLITE_LOCATION_VAR + "/dpm/hostproxy." + SEDPM_INFO_USER;
variable DPM_HOSTPROXY_CMD = "mkdir -p /var/lib/ldap/.globus && /bin/cp /etc/grid-security/hostcert.pem /var/lib/ldap/.globus/usercert.pem && /bin/cp /etc/grid-security/hostkey.pem /var/lib/ldap/.globus/userkey.pem && chown -R " + SEDPM_INFO_USER + " /var/lib/ldap/.globus";
"/software/components/cron/entries" = push(
    dict(
        "name", DPM_HOSTPROXY_CRON,
        "user", "root",
        "frequency", "AUTO 2,8,14,20 * * *",
        "command", DPM_HOSTPROXY_CMD,
    )
);

# Startup script to ensure a valid proxy at boot time (or when the command to generate it is changed
include 'components/filecopy/config';
include 'components/chkconfig/config';
variable DPM_HOSTPROXY_STARTUP = '/etc/init.d/' + DPM_HOSTPROXY_CRON;
variable DPM_HOSTPROXY_STARTUP_CONTENTS = "#!/bin/sh\n" +
                                          "#\n" +
                                          "# chkconfig: - 92 5\n" +
                                          "# description: BDII Service\n" +
                                          DPM_HOSTPROXY_CMD;
'/software/components/filecopy/services' = {
    SELF[escape(DPM_HOSTPROXY_STARTUP)] = dict(
        'config', DPM_HOSTPROXY_STARTUP_CONTENTS,
        'perms', '0755',
        'owner', 'root',
        'restart', DPM_HOSTPROXY_STARTUP,
    );
    SELF;
};
'/software/components/chkconfig' = {
    if ( index('filecopy', SELF['dependencies']['pre']) < 0 ) {
        SELF['dependencies']['pre'][length(SELF['dependencies']['pre'])] = 'filecopy';
    };
    SELF['service'][DPM_HOSTPROXY_CRON]['on'] = "";
    SELF;
};

# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------
include 'components/altlogrotate/config';
"/software/components/altlogrotate/entries" = {
    SELF[DPM_HOSTPROXY_CRON] = dict(
        "pattern", "/var/log/" + DPM_HOSTPROXY_CRON + ".ncm-cron.log",
        "compress", true,
        "missingok", true,
        "frequency", "monthly",
        "create", true,
        "ifempty", true,
        "rotate", 2,
    );
    SELF;
};
