structure template vo/params/icecube;

'name' ?= 'icecube';
'account_prefix' ?= 'icerk';

'voms_servers' ?= list(
    nlist('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15109,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/icecube/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/icecube/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 46000;
