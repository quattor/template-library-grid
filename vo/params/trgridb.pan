structure template vo/params/trgridb;

'name' ?= 'trgridb';
'account_prefix' ?= 'trgtg';

'voms_servers' ?= list(
    nlist('name', 'voms.ulakbim.gov.tr',
          'host', 'voms.ulakbim.gov.tr',
          'port', 15052,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 94000;
