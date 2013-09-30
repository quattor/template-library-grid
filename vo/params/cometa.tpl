structure template vo/params/cometa;

'name' ?= 'cometa';
'account_prefix' ?= 'comskk';

'voms_servers' ?= list(
    nlist('name', 'voms.ct.infn.it',
          'host', 'voms.ct.infn.it',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1892000;
