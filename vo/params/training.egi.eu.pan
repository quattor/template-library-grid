structure template vo/params/training.egi.eu;

'name' ?= 'training.egi.eu';
'account_prefix' ?= 'trafwl';

'voms_servers' ?= list(
    dict('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15014,
          'adminport', 8443,
         ),
    dict('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15014,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10317000;
