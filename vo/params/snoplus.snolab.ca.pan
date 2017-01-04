structure template vo/params/snoplus.snolab.ca;

'name' ?= 'snoplus.snolab.ca';
'account_prefix' ?= 'snotku';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15503,
          'adminport', 8443,
         ),
    dict('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15503,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15503,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    dict('description', 'SW manager',
#          'fqan', '/snoplus.snolab.ca/Role=lcgadmin/Capability=NULL',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
    dict('description', 'production',
          'fqan', '/snoplus.snolab.ca/Role=production/Capability=NULL',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 2552000;
