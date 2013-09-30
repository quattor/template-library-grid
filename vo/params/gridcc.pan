structure template vo/params/gridcc;

'name' ?= 'gridcc';
'account_prefix' ?= 'griuq';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15060,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 104000;
