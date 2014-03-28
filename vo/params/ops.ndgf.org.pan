structure template vo/params/ops.ndgf.org;

'name' ?= 'ops.ndgf.org';
'account_prefix' ?= 'opstbi';

'voms_servers' ?= list(
    nlist('name', 'voms.ndgf.org',
          'host', 'voms.ndgf.org',
          'port', 15010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2332000;
