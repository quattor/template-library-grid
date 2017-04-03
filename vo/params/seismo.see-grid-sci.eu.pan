structure template vo/params/seismo.see-grid-sci.eu;

'name' ?= 'seismo.see-grid-sci.eu';
'account_prefix' ?= 'seittw';

'voms_servers' ?= list(
    dict('name', 'voms.ulakbim.gov.tr',
          'host', 'voms.ulakbim.gov.tr',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2112000;
