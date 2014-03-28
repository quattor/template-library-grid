structure template vo/params/grid.uniovi.es;

'name' ?= 'grid.uniovi.es';
'account_prefix' ?= 'grirqe';

'voms_servers' ?= list(
    nlist('name', 'cmgvoms.mieres.uniovi.es',
          'host', 'cmgvoms.mieres.uniovi.es',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 690000;
