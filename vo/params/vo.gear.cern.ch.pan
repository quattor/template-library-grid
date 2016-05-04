structure template vo/params/vo.gear.cern.ch;

'name' ?= 'vo.gear.cern.ch';
'account_prefix' ?= 'geaie';

'voms_servers' ?= list(
    nlist('name', 'lcg-voms2.cern.ch',
          'host', 'lcg-voms2.cern.ch',
          'port', 15002,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cern.ch',
          'host', 'voms.cern.ch',
          'port', 15008,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.gear.cern.ch/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 482000;
