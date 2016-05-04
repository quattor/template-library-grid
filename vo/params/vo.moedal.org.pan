structure template vo/params/vo.moedal.org;

'name' ?= 'vo.moedal.org';
'account_prefix' ?= 'moefwk';

'voms_servers' ?= list(
    nlist('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15017,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10316000;
