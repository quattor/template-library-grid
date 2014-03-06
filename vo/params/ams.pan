structure template vo/params/ams;

'name' ?= 'ams';
'account_prefix' ?= 'amssr';

'voms_servers' ?= list(
    nlist('name', 'rdig-registrar.sinp.msu.ru',
          'host', 'rdig-registrar.sinp.msu.ru',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 53000;
