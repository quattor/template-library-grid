structure template vo/params/vo.ifisc.csic.es;

'name' ?= 'vo.ifisc.csic.es';
'account_prefix' ?= 'ifituq';

'voms_servers' ?= list(
    dict('name', 'voms.ific.uv.es',
          'host', 'voms.ific.uv.es',
          'port', 14012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2132000;
