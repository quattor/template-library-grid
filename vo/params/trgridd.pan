structure template vo/params/trgridd;

'name' ?= 'trgridd';
'account_prefix' ?= 'trgti';

'voms_servers' ?= list(
    nlist('name', 'voms.ulakbim.gov.tr',
          'host', 'voms.ulakbim.gov.tr',
          'port', 15054,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 96000;
