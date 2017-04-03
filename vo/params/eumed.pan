structure template vo/params/eumed;

'name' ?= 'eumed';
'account_prefix' ?= 'eumab';

'voms_servers' ?= list(
    dict('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15016,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15016,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/eumed/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 271000;
