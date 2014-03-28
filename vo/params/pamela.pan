structure template vo/params/pamela;

'name' ?= 'pamela';
'account_prefix' ?= 'pamuu';

'voms_servers' ?= list(
    nlist('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15013,
          'adminport', 8443,
         ),
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'General analysis group',
          'fqan', '/pamela/Role=PAMELA-Analysis',
          'suffix', 'rsuu',
          'suffix2', 'wmllevr',
         ),
    nlist('description', 'SW manager',
          'fqan', '/pamela/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'VO administration group',
          'fqan', '/pamela/Role=VO-Admin',
          'suffix', 'luu',
          'suffix2', 'tgvfehp',
         ),
);

'base_uid' ?= 108000;
