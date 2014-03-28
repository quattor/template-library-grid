structure template vo/params/pvier;

'name' ?= 'pvier';
'account_prefix' ?= 'pvij';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/pvier/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 19000;
