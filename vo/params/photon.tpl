structure template vo/params/photon;

'name' ?= 'photon';
'account_prefix' ?= 'phosq';

'voms_servers' ?= list(
    nlist('name', 'rdig-registrar.sinp.msu.ru',
          'host', 'rdig-registrar.sinp.msu.ru',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 52000;
