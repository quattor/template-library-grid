structure template vo/params/vo.ops.csic.es;

'name' ?= 'vo.ops.csic.es';
'account_prefix' ?= 'opsrdg';

'voms_servers' ?= list(
    dict('name', 'voms.ific.uv.es',
          'host', 'voms.ific.uv.es',
          'port', 14010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1030000;
