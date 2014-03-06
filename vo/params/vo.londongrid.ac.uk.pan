structure template vo/params/vo.londongrid.ac.uk;

'name' ?= 'vo.londongrid.ac.uk';
'account_prefix' ?= 'lonja';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15021,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'SW manager',
#          'fqan', '/vo.londongrid.ac.uk/ROLE=lcgadmin',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
#    nlist('description', 'production',
#          'fqan', '/vo.londongrid.ac.uk/ROLE=production',
#          'suffix', 'p',
#          'suffix2', 'p',
#         ),
);

'base_uid' ?= 504000;
