structure template vo/params/trgride;

'name' ?= 'trgride';
'account_prefix' ?= 'trgtj';

'voms_servers' ?= list(
    dict('name', 'voms.ulakbim.gov.tr',
          'host', 'voms.ulakbim.gov.tr',
          'port', 15055,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 97000;
