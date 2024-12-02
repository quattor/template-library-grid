structure template vo/params/hgdemo;

'name' ?= 'hgdemo';
'account_prefix' ?= 'hgdsai';

'voms_servers' ?= list(
    dict('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15030,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/hgdemo/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1630000;
