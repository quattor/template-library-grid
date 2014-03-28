structure template vo/params/desktopgrid.vo.edges-grid.eu;

'name' ?= 'desktopgrid.vo.edges-grid.eu';
'account_prefix' ?= 'desrcs';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.edges-grid.eu',
          'host', 'voms.grid.edges-grid.eu',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 990000;
