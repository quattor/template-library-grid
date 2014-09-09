unique template personality/px/service;

variable MYPROXY_SERVER_FLAVOR ?= 'glite';
variable MYPROXY_SERVER_CONFIG_FILE ?= '/etc/myproxy-server.config';
variable MYPROXY_SERVER_DAEMON_NAME ?= 'myproxy-server';

# Add RPMs for PX
include { 'personality/px/rpms' };

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Modify the loadable library path. 
include { 'features/ldconf/config' };

# gLite and Globus sysconfig and environment variables.
include { 'features/globus/sysconfig' };
include { 'features/globus/env' };

# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Ensure that the host certificates have the correct permissions.
include { 'features/security/host_certs' };

# Configure BDII + information provider
variable NODE_USE_RESOURCE_BDII = true;
variable BDII_TYPE ?= 'resource';
include { 'personality/bdii/service' };

# Configure Globus
include { 'features/globus/base' };

# Include the proxy configuration. 
include { 'personality/px/config' };

# Configure the information provider.
include { 'features/gip/base' };
include { 'features/gip/px' };
