structure template vo/params/cesga;

'name' ?= 'cesga';
'account_prefix' ?= 'ceste';

'voms_servers' ?= list(
    nlist('name', 'voms.egi.cesga.es',
          'host', 'voms.egi.cesga.es',
          'port', 15110,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 92000;
