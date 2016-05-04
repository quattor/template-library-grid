structure template vo/params/vo.turbo.pic.es;

'name' ?= 'vo.turbo.pic.es';
'account_prefix' ?= 'tursws';

'voms_servers' ?= list(
    nlist('name', 'voms01.pic.es',
          'host', 'voms01.pic.es',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1510000;
