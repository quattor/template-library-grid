structure template vo/params/fedcloud.egi.eu;

'name' ?= 'fedcloud.egi.eu';
'account_prefix' ?= 'fedfvu';

'voms_servers' ?= list(
    nlist('name', 'voms1.egee.cesnet.cz',
          'host', 'voms1.egee.cesnet.cz',
          'port', 15002,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15002,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10274000;
