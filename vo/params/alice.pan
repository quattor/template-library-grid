structure template vo/params/alice;

'name' ?= 'alice';
'account_prefix' ?= 'alis';

'voms_servers' ?= list(
    nlist('name', 'lcg-voms.cern.ch',
          'host', 'lcg-voms.cern.ch',
          'port', 15000,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cern.ch',
          'host', 'voms.cern.ch',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'pilot',
          'fqan', '/alice/Role=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
    nlist('description', '',
          'fqan', '/alice/Role=root',
          'suffix', 'gs',
          'suffix2', 'vznixia',
         ),
    nlist('description', 'production',
          'fqan', '/alice/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'SW manager',
          'fqan', '/alice/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', '',
          'fqan', '/alice/lcg1',
          'suffix', 'bs',
          'suffix2', 'towwyo',
         ),
);

'base_uid' ?= 2000;
