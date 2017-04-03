structure template vo/params/ific;

'name' ?= 'ific';
'account_prefix' ?= 'ifitk';

'voms_servers' ?= list(
    dict('name', 'swevo.ific.uv.es',
          'host', 'swevo.ific.uv.es',
          'port', 14001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 98000;
