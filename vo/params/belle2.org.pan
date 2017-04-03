structure template vo/params/belle2.org;

'name' ?= 'belle2.org';
'account_prefix' ?= 'belskj';

'voms_servers' ?= list(
    dict('name', 'voms.cc.kek.jp',
          'host', 'voms.cc.kek.jp',
          'port', 15026,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/belle2.org/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/belle2.org/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 1891000;
