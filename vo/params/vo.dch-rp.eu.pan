structure template vo/params/vo.dch-rp.eu;

'name' ?= 'vo.dch-rp.eu';
'account_prefix' ?= 'dchfvx';

'voms_servers' ?= list(
    nlist('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10277000;
