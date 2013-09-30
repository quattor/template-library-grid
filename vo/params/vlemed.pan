structure template vo/params/vlemed;

'name' ?= 'vlemed';
'account_prefix' ?= 'vlermm';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vlemed/Role=sgm',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1270000;
