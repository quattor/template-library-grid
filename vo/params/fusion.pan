structure template vo/params/fusion;

'name' ?= 'fusion';
'account_prefix' ?= 'fussj';

'voms_servers' ?= list(
    nlist('name', 'voms-prg.bifi.unizar.es',
          'host', 'voms-prg.bifi.unizar.es',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'Software Manager Role',
          'fqan', '/fusion/Role=VO-admin',
          'suffix', 'lsj',
          'suffix2', 'tiiwphv',
         ),
    nlist('description', 'production',
          'fqan', '/fusion/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'SW manager',
          'fqan', '/fusion/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 71000;
