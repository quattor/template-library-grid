unique template features/mysql/server;

include 'components/chkconfig/config';
include 'components/etcservices/config';

# Include RPMs for MySQL server
'/software/packages' = pkg_repl('mysql-server');

# Enable and start MySQL service
"/software/components/chkconfig/service" ?= dict();
"/software/components/chkconfig/service" = merge(SELF, dict(
    mysqld, dict(
        'on', '',
        'startstop', true,
    ),
));

"/software/components/etcservices/entries" ?= list();
"/software/components/etcservices/entries" = merge(SELF, list(
    "mariadb 3306/tcp",
    "mariadb 3306/udp",
));
