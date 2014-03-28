structure template vo/params/swetest;

'name' ?= 'swetest';
'account_prefix' ?= 'swese';

'voms_servers' ?= list(
    nlist('name', 'swevo.ific.uv.es',
          'host', 'swevo.ific.uv.es',
          'port', 14000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 66000;
