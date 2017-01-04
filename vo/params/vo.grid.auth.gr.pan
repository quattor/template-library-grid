structure template vo/params/vo.grid.auth.gr;

'name' ?= 'vo.grid.auth.gr';
'account_prefix' ?= 'grirby';

'voms_servers' ?= list(
    dict('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15140,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.grid.auth.gr/Role=SW-Admin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 970000;
