structure template vo/params/argo;

'name' ?= 'argo';
'account_prefix' ?= 'argtb';

'voms_servers' ?= list(
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'production',
          'fqan', '/argo/Role=ProductionManager',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'SW manager',
          'fqan', '/argo/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 89000;
