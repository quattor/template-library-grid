structure template vo/params/gridit;

'name' ?= 'gridit';
'account_prefix' ?= 'grienl';

'voms_servers' ?= list(
    nlist('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15008,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15008,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/gridit/ROLE=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'dedicated to ANSYS project (not all the sites have to support it)',
          'fqan', '/gridit/ansys',
          'suffix', 'denl',
          'suffix2', 'uhrpqvn',
         ),
    nlist('description', 'for testing the auger software',
          'fqan', '/gridit/auger',
          'suffix', 'uzenl',
          'suffix2', 'uhsaujt',
         ),
    nlist('description', 'openfoam application',
          'fqan', '/gridit/openfoam',
          'suffix', 'genl',
          'suffix2', 'rbbdnki',
         ),
);

'base_uid' ?= 10083000;
