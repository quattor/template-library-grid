structure template vo/params/oper.vo.eu-eela.eu;

'name' ?= 'oper.vo.eu-eela.eu';
'account_prefix' ?= 'operzq';

'voms_servers' ?= list(
    nlist('name', 'voms-eela.ceta-ciemat.es',
          'host', 'voms-eela.ceta-ciemat.es',
          'port', 15004,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms.eela.ufrj.br',
          'host', 'voms.eela.ufrj.br',
          'port', 15004,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'Software Manager',
#          'fqan', '/oper.vo.eu-eela.eu/oper.vo.eu-eela.eu/LCGAdmin',
#          'suffix', 'rlrzq',
#          'suffix2', 'raxydzg',
#         ),
#    nlist('description', 'Production',
#          'fqan', '/oper.vo.eu-eela.eu/oper.vo.eu-eela.eu/production',
#          'suffix', 'rnrzq',
#          'suffix2', 'yzjcbsy',
#         ),
);

'base_uid' ?= 910000;
