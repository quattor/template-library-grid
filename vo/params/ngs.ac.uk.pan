structure template vo/params/ngs.ac.uk;

'name' ?= 'ngs.ac.uk';
'account_prefix' ?= 'ngsrv';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15010,
          'adminport', 8443,
         ),
    nlist('name', 'voms.ngs.ac.uk',
          'host', 'voms.ngs.ac.uk',
          'port', 15010,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'SW manager',
#          'fqan', '/ngs.ac.uk/Role=Operations',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
);

'base_uid' ?= 31000;
