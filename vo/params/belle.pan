structure template vo/params/belle;

'name' ?= 'belle';
'account_prefix' ?= 'belsf';

'voms_servers' ?= list(
    nlist('name', 'voms.cc.kek.jp',
          'host', 'voms.cc.kek.jp',
          'port', 15020,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', '',
          'fqan', '/belle/Role=VO-Admin',
          'suffix', 'ksf',
          'suffix2', 'tgvfehp',
         ),
    nlist('description', 'SW manager',
          'fqan', '/belle/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/belle/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 67000;
