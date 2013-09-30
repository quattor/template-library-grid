structure template vo/params/comet.j-parc.jp;

'name' ?= 'comet.j-parc.jp';
'account_prefix' ?= 'comfvt';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15505,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10273000;
