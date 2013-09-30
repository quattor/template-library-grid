structure template vo/params/meteo.see-grid-sci.eu;

'name' ?= 'meteo.see-grid-sci.eu';
'account_prefix' ?= 'metrpu';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15150,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1330000;
