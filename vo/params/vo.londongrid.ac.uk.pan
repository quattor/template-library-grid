structure template vo/params/vo.londongrid.ac.uk;

'name' ?= 'vo.londongrid.ac.uk';
'account_prefix' ?= 'lonja';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15021,
          'adminport', 8443,
         ),
    dict('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15021,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15021,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    dict('description', 'pilot',
          'fqan', '/vo.londongrid.ac.uk/ROLE=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
#    dict('description', 'SW manager',
#          'fqan', '/vo.londongrid.ac.uk/ROLE=lcgadmin',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
#    dict('description', 'production',
#          'fqan', '/vo.londongrid.ac.uk/ROLE=production',
#          'suffix', 'p',
#          'suffix2', 'p',
#         ),
);

'base_uid' ?= 504000;
