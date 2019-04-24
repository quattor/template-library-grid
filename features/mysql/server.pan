
unique template features/mysql/server;

# Include RPMs for MySQL server
'/software/packages/{mariadb-server}' = nlist();

# ----------------------------------------------------------------------------
# chkconfig
# ----------------------------------------------------------------------------
include 'components/chkconfig/config';


# ----------------------------------------------------------------------------
# Enable and start MySQL service
# ----------------------------------------------------------------------------
variable DAEMON_MYSQL ?= "mariadb";
"/software/components/chkconfig/service/" = npush(DAEMON_MYSQL , dict(
    'on', '',
    'startstop', true,
));


# ----------------------------------------------------------------------------
# iptables
# ----------------------------------------------------------------------------
#include { 'components/iptables/config' };

# Inbound port(s).
# Port 3306.  Probably should limit to localhost traffic for most services.

# Outbound port(s).


# ----------------------------------------------------------------------------
# etcservices
# ----------------------------------------------------------------------------
include 'components/etcservices/config';

"/software/components/etcservices/entries" =
    push("mariadb 3306/tcp");
"/software/components/etcservices/entries" =
    push("mariadb 3306/udp");


# ----------------------------------------------------------------------------
# cron
# ----------------------------------------------------------------------------
#include { 'components/cron/config' };


# ----------------------------------------------------------------------------
# altlogrotate
# ----------------------------------------------------------------------------
#include { 'components/altlogrotate/config' };

