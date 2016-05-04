structure template vo/params/hyperk.org;

'name' ?= 'hyperk.org';
'account_prefix' ?= 'hypfve';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15510,
          'adminport', 8443,
         ),
    nlist('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15510,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15510,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'pilot',
#          'fqan', '/hyperk.org/Role=pilot',
#          'suffix', 'pilot',
#          'suffix2', 'pilot',
#         ),
    nlist('description', 'SW manager',
          'fqan', '/hyperk.org/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/hyperk.org/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 10284000;
