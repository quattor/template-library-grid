structure template vo/params/comet.j-parc.jp;

'name' ?= 'comet.j-parc.jp';
'account_prefix' ?= 'comfvt';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15505,
          'adminport', 8443,
         ),
    nlist('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15505,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15505,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'pilot',
#          'fqan', '/comet.j-parc.jp/ROLE=Pilot',
#          'suffix', 'pilot',
#          'suffix2', 'pilot',
#         ),
#    nlist('description', 'SW manager',
#          'fqan', '/comet.j-parc.jp/ROLE=lcgadmin',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
#    nlist('description', 'production',
#          'fqan', '/comet.j-parc.jp/ROLE=production',
#          'suffix', 'p',
#          'suffix2', 'p',
#         ),
);

'base_uid' ?= 10273000;
