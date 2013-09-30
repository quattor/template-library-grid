structure template vo/params/gilda;

'name' ?= 'gilda';
'account_prefix' ?= 'giljq';

'voms_servers' ?= list(
    nlist('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 494000;
