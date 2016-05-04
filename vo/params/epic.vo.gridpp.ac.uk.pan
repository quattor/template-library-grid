structure template vo/params/epic.vo.gridpp.ac.uk;

'name' ?= 'epic.vo.gridpp.ac.uk';
'account_prefix' ?= 'epifvw';

'voms_servers' ?= list(
    nlist('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15507,
          'adminport', 8443,
         ),
    nlist('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15027,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15027,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'SW manager',
#          'fqan', '/epic.vo.gridpp.ac.uk/Role=sgm/Capability=NULL',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
);

'base_uid' ?= 10276000;
