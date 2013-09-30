structure template vo/params/vo.landslides.mossaic.org;

'name' ?= 'vo.landslides.mossaic.org';
'account_prefix' ?= 'lanfuh';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10261000;
