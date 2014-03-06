structure template vo/params/lattice.itep.ru;

'name' ?= 'lattice.itep.ru';
'account_prefix' ?= 'latssw';

'voms_servers' ?= list(
    nlist('name', 'rdig-registrar.sinp.msu.ru',
          'host', 'rdig-registrar.sinp.msu.ru',
          'port', 15007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1410000;
