structure template vo/params/hydrology.terradue.com;

'name' ?= 'hydrology.terradue.com';
'account_prefix' ?= 'hydfwh';

'voms_servers' ?= list(
    nlist('name', 'voms.ba.infn.it',
          'host', 'voms.ba.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10313000;
