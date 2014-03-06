structure template vo/params/na62.vo.gridpp.ac.uk;

'name' ?= 'na62.vo.gridpp.ac.uk';
'account_prefix' ?= 'na6fvq';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10270000;
