unique template features/mariadb/server;

include 'components/chkconfig/config';

prefix '/software/components/chkconfig/service';
'mariadb/on' = '';
'mariadb/startstop' = true;

include 'components/mysql/config';

prefix '/software/components/mysql';

'serviceName' = 'mariadb';

prefix '/software/packages';
'{mariadb}' ?= dict();
'{mariadb-server}' ?= dict();
'{MySQL-python}' ?= dict();
