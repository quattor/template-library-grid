structure template vo/params/alice;

'name' ?= 'alice';
'account_prefix' ?= 'alis';

'voms_servers' ?= list(
    dict('name', 'lcg-voms2.cern.ch',
          'host', 'lcg-voms2.cern.ch',
          'port', 15000,
          'adminport', 8443,
         ),
    dict('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'pilot',
          'fqan', '/alice/Role=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
    dict('description', '',
          'fqan', '/alice/Role=root',
          'suffix', 'gs',
          'suffix2', 'vznixia',
         ),
    dict('description', 'production',
          'fqan', '/alice/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'SW manager',
          'fqan', '/alice/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', '',
          'fqan', '/alice/lcg1',
          'suffix', 'bs',
          'suffix2', 'towwyo',
         ),
);

'base_uid' ?= 2000;
