structure template vo/params/lz;

'name' ?= 'lz';
'account_prefix' ?= 'lzfwo';

'voms_servers' ?= list(
    dict('name', 'voms.hep.wisc.edu',
          'host', 'voms.hep.wisc.edu',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10320000;
