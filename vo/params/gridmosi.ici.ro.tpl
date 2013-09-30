structure template vo/params/gridmosi.ici.ro;

'name' ?= 'gridmosi.ici.ro';
'account_prefix' ?= 'grihr';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.ici.ro',
          'host', 'voms.grid.ici.ro',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 443000;
