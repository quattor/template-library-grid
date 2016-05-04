structure template vo/params/vo.scotgrid.ac.uk;

'name' ?= 'vo.scotgrid.ac.uk';
'account_prefix' ?= 'scoiv';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15509,
          'adminport', 8443,
         ),
    nlist('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15509,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15509,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 473000;
