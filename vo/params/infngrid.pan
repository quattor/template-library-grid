structure template vo/params/infngrid;

'name' ?= 'infngrid';
'account_prefix' ?= 'infm';

'voms_servers' ?= list(
    nlist('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15000,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'pilot',
          'fqan', '/infngrid/Role=pilot',
          'suffix', 'pilot',
          'suffix2', 'pilot',
         ),
    nlist('description', 'SW manager',
          'fqan', '/infngrid/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'for Storm developers',
          'fqan', '/infngrid/Role=Storm-Test',
          'suffix', 'pm',
          'suffix2', 'dilbcai',
         ),
    nlist('description', 'for JRA1 developers',
          'fqan', '/infngrid/Role=TEST-jra1',
          'suffix', 'om',
          'suffix2', 'bevkeqj',
         ),
    nlist('description', 'VO admins',
          'fqan', '/infngrid/Role=VO-Admin',
          'suffix', 'nm',
          'suffix2', 'tgvfehp',
         ),
);

'base_uid' ?= 22000;
