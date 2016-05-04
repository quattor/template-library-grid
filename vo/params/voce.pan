structure template vo/params/voce;

'name' ?= 'voce';
'account_prefix' ?= 'vocsv';

'voms_servers' ?= list(
    nlist('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 7001,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 7001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 57000;
