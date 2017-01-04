structure template vo/params/desy;

'name' ?= 'desy';
'account_prefix' ?= 'desra';

'voms_servers' ?= list(
    dict('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15104,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', '',
          'fqan', '/desy/Role=lcgadim',
          'suffix', 'ira',
          'suffix2', 'rhyqmcf',
         ),
    dict('description', 'production',
          'fqan', '/desy/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 36000;
