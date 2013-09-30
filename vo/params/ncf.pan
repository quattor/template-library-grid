structure template vo/params/ncf;

'name' ?= 'ncf';
'account_prefix' ?= 'ncfk';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30014,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 20000;
