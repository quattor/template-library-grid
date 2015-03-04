structure template vo/params/vo.sixt.cern.ch;

'name' ?= 'vo.sixt.cern.ch';
'account_prefix' ?= 'sixc';

'voms_servers' ?= list(
    nlist('name', 'lcg-voms2.cern.ch',
          'host', 'lcg-voms2.cern.ch',
          'port', 15005,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.sixt.cern.ch/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 12000;
