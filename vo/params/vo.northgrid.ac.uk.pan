structure template vo/params/vo.northgrid.ac.uk;

'name' ?= 'vo.northgrid.ac.uk';
'account_prefix' ?= 'noriy';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15018,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 476000;
