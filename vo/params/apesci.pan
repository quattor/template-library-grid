structure template vo/params/apesci;

'name' ?= 'apesci';
'account_prefix' ?= 'apeso';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sinica.edu.tw',
          'host', 'voms.grid.sinica.edu.tw',
          'port', 15011,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/apesci/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 76000;
