
unique template features/mysql/server;

# Include RPMs for MySQL server
'/software/packages/{mysql-server}' = nlist();

# ---------------------------------------------------------------------------- 
# chkconfig
# ---------------------------------------------------------------------------- 
include { 'components/chkconfig/config' };


# ---------------------------------------------------------------------------- 
# Enable and start MySQL service
# ---------------------------------------------------------------------------- 
"/software/components/chkconfig/service/mysqld/on" = ""; 
"/software/components/chkconfig/service/mysqld/startstop" = true; 


# ---------------------------------------------------------------------------- 
# accounts
# ---------------------------------------------------------------------------- 
include { 'users/mysql' };


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
include { 'components/etcservices/config' };

"/software/components/etcservices/entries" = 
  push("mysql 3306/tcp");
"/software/components/etcservices/entries" = 
  push("mysql 3306/udp");


# ---------------------------------------------------------------------------- 
# cron
# ---------------------------------------------------------------------------- 
#include { 'components/cron/config' };


# ---------------------------------------------------------------------------- 
# altlogrotate
# ---------------------------------------------------------------------------- 
#include { 'components/altlogrotate/config' }; 

