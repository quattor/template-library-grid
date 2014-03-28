structure template vo/params/see;

'name' ?= 'see';
'account_prefix' ?= 'seesw';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15010,
          'adminport', 8443,
         ),
    nlist('name', 'voms.irb.hr',
          'host', 'voms.irb.hr',
          'port', 15011,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 58000;
