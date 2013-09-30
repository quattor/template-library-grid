structure template vo/params/bio;

'name' ?= 'bio';
'account_prefix' ?= 'biorm';

'voms_servers' ?= list(
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', '',
          'fqan', '/bio/libi',
          'suffix', 'zrm',
          'suffix2', 'towein',
         ),
    nlist('description', '',
          'fqan', '/bio/bioinfogrid',
          'suffix', 'grm',
          'suffix2', 'dqydaht',
         ),
    nlist('description', 'SW manager',
          'fqan', '/bio/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', '',
          'fqan', '/bio/Role=VO-Admin',
          'suffix', 'irm',
          'suffix2', 'tgvfehp',
         ),
);

'base_uid' ?= 48000;
