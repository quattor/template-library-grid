structure template vo/params/ilc;

'name' ?= 'ilc';
'account_prefix' ?= 'ilcre';

'voms_servers' ?= list(
    nlist('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15110,
          'adminport', 8443,
         ),
    nlist('name', 'voms.fnal.gov',
          'host', 'voms.fnal.gov',
          'port', 15023,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'pilot',
          'fqan', '/ilc/Role=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
    nlist('description', 'SW manager',
          'fqan', '/ilc/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/ilc/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 40000;
