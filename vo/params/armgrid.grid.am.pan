structure template vo/params/armgrid.grid.am;

'name' ?= 'armgrid.grid.am';
'account_prefix' ?= 'armstk';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.am',
          'host', 'voms.grid.am',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/armgrid.grid.am/Role=VO-Admin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1450000;
