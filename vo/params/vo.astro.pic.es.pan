structure template vo/params/vo.astro.pic.es;

'name' ?= 'vo.astro.pic.es';
'account_prefix' ?= 'astfuo';

'voms_servers' ?= list(
    nlist('name', 'voms01.pic.es',
          'host', 'voms01.pic.es',
          'port', 15004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10268000;
