structure template vo/params/xfel.eu;

'name' ?= 'xfel.eu';
'account_prefix' ?= 'xferae';

'voms_servers' ?= list(
    nlist('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15113,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/xfel.eu/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/xfel.eu/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 950000;
