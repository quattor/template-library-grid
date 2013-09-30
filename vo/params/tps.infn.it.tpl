structure template vo/params/tps.infn.it;

'name' ?= 'tps.infn.it';
'account_prefix' ?= 'tpsrsm';

'voms_servers' ?= list(
    nlist('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15015,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15015,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 750000;
