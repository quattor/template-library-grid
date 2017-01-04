structure template vo/params/balticgrid;

'name' ?= 'balticgrid';
'account_prefix' ?= 'balvq';

'voms_servers' ?= list(
    dict('name', 'voms.balticgrid.org',
          'host', 'voms.balticgrid.org',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 130000;
