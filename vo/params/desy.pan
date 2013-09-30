structure template vo/params/desy;

'name' ?= 'desy';
'account_prefix' ?= 'desra';

'voms_servers' ?= list(
    nlist('name', 'grid-voms.desy.de',
          'host', 'grid-voms.desy.de',
          'port', 15104,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', '',
          'fqan', '/desy/Role=lcgadim',
          'suffix', 'ira',
          'suffix2', 'rhyqmcf',
         ),
    nlist('description', 'production',
          'fqan', '/desy/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 36000;
