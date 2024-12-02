structure template vo/params/theophys;

'name' ?= 'theophys';
'account_prefix' ?= 'therq';

'voms_servers' ?= list(
    dict('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 26000;
