structure template vo/params/na62.vo.gridpp.ac.uk;

'name' ?= 'na62.vo.gridpp.ac.uk';
'account_prefix' ?= 'na6fvq';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15501,
          'adminport', 8443,
         ),
    dict('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15501,
          'adminport', 8443,
         ),
    dict('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15501,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10270000;
