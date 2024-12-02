structure template vo/params/vo.access.egi.eu;

'name' ?= 'vo.access.egi.eu';
'account_prefix' ?= 'accfye';

'voms_servers' ?= list(
    dict('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15031,
          'adminport', 8443,
         ),
    dict('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15031,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10362000;
