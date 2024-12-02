structure template vo/params/trgrida;

'name' ?= 'trgrida';
'account_prefix' ?= 'trgtf';

'voms_servers' ?= list(
    dict('name', 'voms.ulakbim.gov.tr',
          'host', 'voms.ulakbim.gov.tr',
          'port', 15051,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 93000;
