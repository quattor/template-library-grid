# Configuration specific to disk servers

unique template personality/se_dpm/disk/service;

variable NET_CORE_RMEM_MAX ?= 2097152;
variable NET_CORE_WMEM_MAX ?= NET_CORE_RMEM_MAX;
variable NET_CORE_NETDEV_MAX_BACKLOG ?= 10000;
# Use either of TCP_RMEM or TCP_WMEM as the default for the other
variable NET_IPV4_TCP_RMEM ?= if ( is_defined(NET_IPV4_TCP_WMEM) ) {
                                 NET_IPV4_TCP_WMEM;
                              } else {
                                '131072 1048576 2097152';
                              };
variable NET_IPV4_TCP_WMEM ?= NET_IPV4_TCP_RMEM;
variable NET_IPV4_TCP_DSACK ?= 0;
variable NET_IPV4_TCP_SACK ?= 0;
variable NET_IPV4_TCP_TIMESTAMPS ?= 0;

# Tune TCP parameters
include 'components/sysctl/config';
'/software/components/sysctl/variables' = nlist(
    'net.core.rmem_max',    to_string(NET_CORE_RMEM_MAX),
    'net.core.wmem_max',    to_string(NET_CORE_WMEM_MAX),
    'net.core.netdev_max_backlog', to_string(NET_CORE_NETDEV_MAX_BACKLOG),
    'net.ipv4.tcp_rmem',    NET_IPV4_TCP_RMEM,
    'net.ipv4.tcp_wmem',    NET_IPV4_TCP_WMEM,
    'net.ipv4.tcp_dsack',   to_string(NET_IPV4_TCP_DSACK),
    'net.ipv4.tcp_sack',    to_string(NET_IPV4_TCP_SACK),
    'net.ipv4.tcp_timestamps', to_string(NET_IPV4_TCP_TIMESTAMPS),
);
