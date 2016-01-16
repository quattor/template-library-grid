structure template vo/params/ops;

'name' ?= 'ops';
'account_prefix' ?= 'opssg';

'voms_servers' ?= list(
    nlist('name', 'lcg-voms2.cern.ch',
          'host', 'lcg-voms2.cern.ch',
          'port', 15009,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'pilot',
          'fqan', '/ops/Role=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
    nlist('description', 'SW manager',
          'fqan', '/ops/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 68000;
