structure template vo/params/astron;

'name' ?= 'astron';
'account_prefix' ?= 'astrf';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 41000;
