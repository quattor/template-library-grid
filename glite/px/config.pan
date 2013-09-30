unique template glite/px/config;

variable MYPROXY_PORT ?= 7512;

#
# Variables to define the different policies. Values should be lists of DNs.
# There are 2 set of policies : explicitly authorized and default with 4
# possible actions : renewers, retrievers, key_retrievers and
# trusted_retrievers.
# A trusted retriever is automatically added as a retriever.
# See man myproxy-server.config for more details.
#
variable MYPROXY_DEFAULT_RENEWERS ?= undef;
variable MYPROXY_DEFAULT_RETRIEVERS ?= undef;
variable MYPROXY_DEFAULT_KEY_RETRIEVERS ?= undef;
variable MYPROXY_DEFAULT_TRUSTED_RETRIEVERS ?= undef;
variable MYPROXY_AUTHORIZED_RENEWERS ?= undef;
variable MYPROXY_AUTHORIZED_RETRIEVERS ?= undef;
variable MYPROXY_AUTHORIZED_KEY_RETRIEVERS ?= undef;
variable MYPROXY_AUTHORIZED_TRUSTED_RETRIEVERS ?= undef;

#
# Add to authorized renewers GRID_TRUSTED_BROKERS (WMS)
#
variable MYPROXY_AUTHORIZED_RENEWERS = {
  if ( is_defined(GRID_TRUSTED_BROKERS) ) {
    if ( is_list(SELF) ) {
      renewers = SELF;
      renewers = merge(renewers,GRID_TRUSTED_BROKERS);
      renewers;
    } else {
      GRID_TRUSTED_BROKERS;
    };
  } else {
    SELF;
  };
};


#
# chkconfig
#
include { 'components/chkconfig/config' };
'/software/components/chkconfig/service/myproxy-server/on' = '';
'/software/components/chkconfig/service/myproxy-server/startstop' = true;


#
# iptables
#
include { 'components/iptables/config' };

# Inbound port(s).
'/software/components/iptables/filter/rules' = push(nlist(
    'command', '-A',
    'chain', 'input',
    'match', 'state',
    'state', 'NEW',
    'protocol', 'tcp',
    'dst_port', to_string(MYPROXY_PORT),
    'target', 'accept',
));


#
# etcservices
#
include { 'components/etcservices/config' };
'/software/components/etcservices/entries' = push('myproxy '+to_string(MYPROXY_PORT)+'/tcp');


#
# sysconfig
# Add GLITE_LOCATION in case it is non standard as it is used in startup driver
#
include { 'components/sysconfig/config' };
'/software/components/sysconfig/files/globus/GLITE_LOCATION' = GLITE_LOCATION;


#
# Certificate and key
#
include { 'components/filecopy/config' };
'/software/components/filecopy/services/{/etc/grid-security/myproxy/hostcert.pem}' = nlist(
    'source', '/etc/grid-security/hostcert.pem',
    'owner', 'myproxy',
    'group', 'myproxy',
    'perms', '0444',
    'backup', false,
);
'/software/components/filecopy/services/{/etc/grid-security/myproxy/hostkey.pem}' = nlist(
    'source', '/etc/grid-security/hostkey.pem',
    'owner', 'myproxy',
    'group', 'myproxy',
    'perms', '0400',
    'backup', false,
);


#
# myproxy
#
include { 'components/myproxy/config' };
'/software/components/myproxy/dependencies/pre' = push('globuscfg');
'/software/components/myproxy/flavor' = MYPROXY_SERVER_FLAVOR;
'/software/components/myproxy/confFile' = MYPROXY_SERVER_CONFIG_FILE;
'/software/components/myproxy/daemonName' = MYPROXY_SERVER_DAEMON_NAME;
'/software/components/myproxy/defaultDNs' = {
    if ( is_defined(MYPROXY_DEFAULT_RENEWERS) ) {
        SELF['renewers'] = MYPROXY_DEFAULT_RENEWERS;
    };
    if ( is_defined(MYPROXY_DEFAULT_RETRIEVERS) ) {
        SELF['retrievers'] = MYPROXY_DEFAULT_RETRIEVERS;
    };
    if ( is_defined(MYPROXY_DEFAULT_KEY_RETRIEVERS) ) {
        SELF['keyRetrievers'] = MYPROXY_DEFAULT_KEY_RETRIEVERS;
    };
    if ( is_defined(MYPROXY_DEFAULT_TRUSTED_RETRIEVERS) ) {
        SELF['trustedRetrievers'] = MYPROXY_DEFAULT_TRUSTED_RETRIEVERS;
    };
    if ( length(SELF) > 0 ) {
        SELF;
    } else {
        null;
    };
};
'/software/components/myproxy/authorizedDNs' = {
    if ( is_defined(MYPROXY_AUTHORIZED_RENEWERS) ) {
        SELF['renewers'] = MYPROXY_AUTHORIZED_RENEWERS;
    };
    if ( is_defined(MYPROXY_AUTHORIZED_RETRIEVERS) ) {
        SELF['retrievers'] = MYPROXY_AUTHORIZED_RETRIEVERS;
    };
    if ( is_defined(MYPROXY_AUTHORIZED_KEY_RETRIEVERS) ) {
        SELF['keyRetrievers'] = MYPROXY_AUTHORIZED_KEY_RETRIEVERS;
    };
    if ( is_defined(MYPROXY_AUTHORIZED_TRUSTED_RETRIEVERS) ) {
        SELF['trustedRetrievers'] = MYPROXY_AUTHORIZED_TRUSTED_RETRIEVERS;
    };
    if ( length(SELF) > 0 ) {
        SELF;
    } else {
        null;
    };
};
