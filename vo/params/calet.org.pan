structure template vo/params/calet.org;

'name' ?= 'calet.org';
'account_prefix' ?= 'calfvm';

'voms_servers' ?= list(
    nlist('name', 'vomsIGI-NA.unina.it',
          'host', 'vomsIGI-NA.unina.it',
          'port', 15006,
          'adminport', 8443,
         ),
    nlist('name', 'vomsmania.cnaf.infn.it',
          'host', 'vomsmania.cnaf.infn.it',
          'port', 15006,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/calet.org/ROLE=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 10292000;
