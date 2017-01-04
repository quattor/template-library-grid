structure template vo/params/demo.fedcloud.egi.eu;

'name' ?= 'demo.fedcloud.egi.eu';
'account_prefix' ?= 'demfwq';

'voms_servers' ?= list(
    dict('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15008,
          'adminport', 8443,
         ),
    dict('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15008,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10296000;
