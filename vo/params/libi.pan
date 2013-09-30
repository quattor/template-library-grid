structure template vo/params/libi;

'name' ?= 'libi';
'account_prefix' ?= 'libsk';

'voms_servers' ?= list(
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/libi/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'Admin',
          'fqan', '/libi/Role=VO',
          'suffix', 'dsk',
          'suffix2', 'alnrocr',
         ),
);

'base_uid' ?= 72000;
