structure template vo/params/lights.infn.it;

'name' ?= 'lights.infn.it';
'account_prefix' ?= 'lighm';

'voms_servers' ?= list(
    nlist('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15013,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/lights.infn.it/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'VO administrator',
          'fqan', '/lights.infn.it/Role=VO-Admin',
          'suffix', 'rthm',
          'suffix2', 'tgvfehp',
         ),
);

'base_uid' ?= 464000;
