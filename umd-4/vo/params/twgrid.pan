structure template vo/params/twgrid;

'name' ?= 'twgrid';
'account_prefix' ?= 'twgsn';

'voms_servers' ?= list(
    dict('name', 'voms.grid.sinica.edu.tw',
          'host', 'voms.grid.sinica.edu.tw',
          'port', 15010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/twgrid/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 75000;
