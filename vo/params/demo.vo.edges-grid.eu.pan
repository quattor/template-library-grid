structure template vo/params/demo.vo.edges-grid.eu;

'name' ?= 'demo.vo.edges-grid.eu';
'account_prefix' ?= 'demtdw';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.edges-grid.eu',
          'host', 'voms.grid.edges-grid.eu',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2372000;
