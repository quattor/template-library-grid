structure template vo/params/see;

'name' ?= 'see';
'account_prefix' ?= 'seesw';

'voms_servers' ?= list(
    dict('name', 'voms.hellasgrid.gr',
          'host', 'voms.hellasgrid.gr',
          'port', 15010,
          'adminport', 8443,
         ),
    dict('name', 'voms2.hellasgrid.gr',
          'host', 'voms2.hellasgrid.gr',
          'port', 15010,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 58000;
