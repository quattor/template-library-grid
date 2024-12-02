structure template vo/params/fusion;

'name' ?= 'fusion';
'account_prefix' ?= 'fussj';

'voms_servers' ?= list(
    dict('name', 'voms-prg.bifi.unizar.es',
          'host', 'voms-prg.bifi.unizar.es',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'Software Manager Role',
          'fqan', '/fusion/Role=VO-admin',
          'suffix', 'lsj',
          'suffix2', 'tiiwphv',
         ),
    dict('description', 'production',
          'fqan', '/fusion/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'SW manager',
          'fqan', '/fusion/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 71000;
