structure template vo/params/geohazards.terradue.com;

'name' ?= 'geohazards.terradue.com';
'account_prefix' ?= 'geofwg';

'voms_servers' ?= list(
    dict('name', 'voms.ba.infn.it',
          'host', 'voms.ba.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10312000;
