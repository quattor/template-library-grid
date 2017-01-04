structure template vo/params/cms;

'name' ?= 'cms';
'account_prefix' ?= 'cmsu';

'voms_servers' ?= list(
    dict('name', 'lcg-voms2.cern.ch',
          'host', 'lcg-voms2.cern.ch',
          'port', 15002,
          'adminport', 8443,
         ),
    dict('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'pilot',
          'fqan', '/cms/Role=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
    dict('description', 'SW manager',
          'fqan', '/cms/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/cms/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 4000;
