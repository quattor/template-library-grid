structure template vo/params/ilc;

'name' ?= 'ilc';
'account_prefix' ?= 'ilcre';

'voms_servers' ?= list(
    dict('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15110,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'pilot',
          'fqan', '/ilc/Role=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
    dict('description', 'SW manager',
          'fqan', '/ilc/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/ilc/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 40000;
