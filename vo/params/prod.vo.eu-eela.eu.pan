structure template vo/params/prod.vo.eu-eela.eu;

'name' ?= 'prod.vo.eu-eela.eu';
'account_prefix' ?= 'proryw';

'voms_servers' ?= list(
    dict('name', 'voms-eela.ceta-ciemat.es',
          'host', 'voms-eela.ceta-ciemat.es',
          'port', 15003,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms.grid.unam.mx',
          'host', 'voms.grid.unam.mx',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    dict('description', 'Software Manager',
#          'fqan', '/prod.vo.eu-eela.eu/prod.vo.eu-eela.eu/LCGAdmin',
#          'suffix', 'rlryw',
#          'suffix2', 'aqeqkbx',
#         ),
#    dict('description', 'Production',
#          'fqan', '/prod.vo.eu-eela.eu/prod.vo.eu-eela.eu/production',
#          'suffix', 'rnryw',
#          'suffix2', 'anqgyfz',
#         ),
);

'base_uid' ?= 890000;
