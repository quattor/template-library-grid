structure template vo/params/vo.southgrid.ac.uk;

'name' ?= 'vo.southgrid.ac.uk';
'account_prefix' ?= 'sounc';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15019,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 610000;
