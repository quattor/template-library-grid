structure template vo/params/babar;

'name' ?= 'babar';
'account_prefix' ?= 'babz';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15002,
          'adminport', 8443,
         ),
    nlist('name', 'voms.gridpp.rl.ac.uk',
          'host', 'voms.gridpp.rl.ac.uk',
          'port', 15002,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/babar/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 9000;
