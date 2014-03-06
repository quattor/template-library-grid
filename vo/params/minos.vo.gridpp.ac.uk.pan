structure template vo/params/minos.vo.gridpp.ac.uk;

'name' ?= 'minos.vo.gridpp.ac.uk';
'account_prefix' ?= 'minuv';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15016,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'software manager',
          'fqan', '/minos/Role=lcgadmin',
          'suffix', 'kuv',
          'suffix2', 'thfsfoi',
         ),
);

'base_uid' ?= 109000;
