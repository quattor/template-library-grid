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
    nlist('description', 'VO users',
          'fqan', '/xray.eu',
          'suffix', 'yrae',
          'suffix2', 'zqnzimr',
         ),
    nlist('description', 'VO software manager role',
          'fqan', '/xray.eu/Role=lcgadmin',
          'suffix', 'mrae',
          'suffix2', 'bogtwls',
         ),
    nlist('description', 'VO production role',
          'fqan', '/xray.eu/Role=production',
          'suffix', 'orae',
          'suffix2', 'tdhxgii',
         ),
);

'base_uid' ?= 950000;
