structure template vo/params/cppm;

'name' ?= 'cppm';
'account_prefix' ?= 'cppin';

'voms_servers' ?= list(
    nlist('name', 'marvoms.in2p3.fr',
          'host', 'marvoms.in2p3.fr',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/cppm/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 491000;
