structure template vo/params/vo.general.csic.es;

'name' ?= 'vo.general.csic.es';
'account_prefix' ?= 'genrea';

'voms_servers' ?= list(
    nlist('name', 'voms.ific.uv.es',
          'host', 'voms.ific.uv.es',
          'port', 14011,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1050000;
