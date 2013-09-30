structure template vo/params/sgdemo;

'name' ?= 'sgdemo';
'account_prefix' ?= 'sgdsbc';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15090,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/sgdemo/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1650000;
