structure template vo/params/compchem;

'name' ?= 'compchem';
'account_prefix' ?= 'come';

'voms_servers' ?= list(
    nlist('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15003,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/compchem/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'VO administration',
          'fqan', '/compchem/Role=VOAdmin',
          'suffix', 'me',
          'suffix2', 'wqxtqpc',
         ),
);

'base_uid' ?= 14000;
