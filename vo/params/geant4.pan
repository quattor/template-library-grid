structure template vo/params/geant4;

'name' ?= 'geant4';
'account_prefix' ?= 'geasy';

'voms_servers' ?= list(
    dict('name', 'lcg-voms2.cern.ch',
          'host', 'lcg-voms2.cern.ch',
          'port', 15007,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/geant4/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/geant4/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 60000;
