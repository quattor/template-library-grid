structure template vo/params/pacs.infn.it;

'name' ?= 'pacs.infn.it';
'account_prefix' ?= 'pacrjk';

'voms_servers' ?= list(
    dict('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15019,
          'adminport', 8443,
         ),
    dict('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15019,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1190000;
