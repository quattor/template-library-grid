unique template personality/px/service;

variable MYPROXY_SERVER_FLAVOR ?= 'glite';
variable MYPROXY_SERVER_CONFIG_FILE ?= '/etc/myproxy-server.config';
variable MYPROXY_SERVER_DAEMON_NAME ?= 'myproxy-server';

# Add RPMs for PX
include { 'personality/px/rpms/config' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Modify the loadable library path. 
include { 'feature/ldconf/config' };

# gLite and Globus sysconfig and environment variables.
include { 'feature/globus/sysconfig' };
include { 'feature/globus/env' };

# Add accepted CAs
include { 'security/cas' };

# Update the certificate revocation lists.
include { 'features/fetch-crl/config' };

# Ensure that the host certificates have the correct permissions.
include { 'feature/security/host_certs' };

# Configure BDII + information provider
variable NODE_USE_RESOURCE_BDII = true;
variable BDII_TYPE ?= 'resource';
include { 'personality/bdii/service' };

# Configure Globus
include { 'feature/globus/base' };

# Include the proxy configuration. 
include { 'personality/px/config' };

# Configure the information provider.
include { 'feature/gip/base' };
include { 'feature/gip/px' };
