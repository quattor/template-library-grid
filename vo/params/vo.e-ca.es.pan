structure template vo/params/vo.e-ca.es;

'name' ?= 'vo.e-ca.es';
'account_prefix' ?= 'ecais';

'voms_servers' ?= list(
    nlist('name', 'swevo.ific.uv.es',
          'host', 'swevo.ific.uv.es',
          'port', 14005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 470000;
