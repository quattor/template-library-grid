structure template vo/params/mice;

'name' ?= 'mice';
'account_prefix' ?= 'micfuc';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/mice/ROLE=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'Offline reconstruction',
          'fqan', '/mice/ROLE=reco',
          'suffix', 'ffuc',
          'suffix2', 'yqztzsn',
         ),
);

'base_uid' ?= 10256000;
