structure template vo/params/virgo;

'name' ?= 'virgo';
'account_prefix' ?= 'virb';

'voms_servers' ?= list(
    nlist('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15009,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 11000;
