structure template vo/params/gr-sim.grid.auth.gr;

'name' ?= 'gr-sim.grid.auth.gr';
'account_prefix' ?= 'grstli';

'voms_servers' ?= list(
    dict('name', 'voms.hellasgrid.gr',
          'host', 'voms.hellasgrid.gr',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2592000;
