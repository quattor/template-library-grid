structure template vo/params/euindia;

'name' ?= 'euindia';
'account_prefix' ?= 'euizg';

'voms_servers' ?= list(
    nlist('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15010,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/euindia/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'Admin',
          'fqan', '/euindia/Role=VO',
          'suffix', 'gzg',
          'suffix2', 'alnrocr',
         ),
);

'base_uid' ?= 250000;
