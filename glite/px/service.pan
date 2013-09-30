unique template glite/px/service;

variable MYPROXY_SERVER_FLAVOR ?= 'glite';
variable MYPROXY_SERVER_CONFIG_FILE ?= '/etc/myproxy-server.config';
variable MYPROXY_SERVER_DAEMON_NAME ?= 'myproxy-server';

# Add RPMs for PX
include { 'glite/px/rpms/config' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Modify the loadable library path. 
include { 'common/ldconf/config' };

# gLite and Globus sysconfig and environment variables.
include { 'common/globus/sysconfig' };
include { 'common/globus/env' };

# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Ensure that the host certificates have the correct permissions.
include { 'common/security/host_certs' };

# Configure BDII + information provider
variable NODE_USE_RESOURCE_BDII = true;
variable BDII_TYPE ?= 'resource';
include { 'glite/bdii/service' };

# Configure Globus
include { 'common/globus/base' };

# Include the proxy configuration. 
include { 'glite/px/config' };

# Configure the information provider.
include { 'common/gip/base' };
include { 'common/gip/px' };
