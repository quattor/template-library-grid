structure template vo/params/lsgrid;

'name' ?= 'lsgrid';
'account_prefix' ?= 'lsgsrc';

'voms_servers' ?= list(
    dict('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30018,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1390000;
