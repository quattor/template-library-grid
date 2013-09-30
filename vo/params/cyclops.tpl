structure template vo/params/cyclops;

'name' ?= 'cyclops';
'account_prefix' ?= 'cycys';

'voms_servers' ?= list(
    nlist('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15011,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15011,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/cyclops/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'Admin',
          'fqan', '/cyclops/Role=VO',
          'suffix', 'gys',
          'suffix2', 'alnrocr',
         ),
);

'base_uid' ?= 210000;
