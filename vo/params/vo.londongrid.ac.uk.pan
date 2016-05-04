structure template vo/params/vo.londongrid.ac.uk;

'name' ?= 'vo.londongrid.ac.uk';
'account_prefix' ?= 'lonja';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15021,
          'adminport', 8443,
         ),
    nlist('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15021,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15021,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'pilot',
          'fqan', '/vo.londongrid.ac.uk/ROLE=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
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
