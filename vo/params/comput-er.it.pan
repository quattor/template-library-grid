structure template vo/params/comput-er.it;

'name' ?= 'comput-er.it';
'account_prefix' ?= 'comtau';

'voms_servers' ?= list(
    dict('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15007,
          'adminport', 8443,
         ),
    dict('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/comput-er.it/SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 2292000;
