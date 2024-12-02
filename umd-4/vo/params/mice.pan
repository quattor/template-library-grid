structure template vo/params/mice;

'name' ?= 'mice';
'account_prefix' ?= 'micfuc';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15001,
          'adminport', 8443,
         ),
    dict('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15001,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15001,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/mice/ROLE=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'Offline reconstruction',
          'fqan', '/mice/ROLE=reco',
          'suffix', 'ffuc',
          'suffix2', 'yqztzsn',
         ),
);

'base_uid' ?= 10256000;
