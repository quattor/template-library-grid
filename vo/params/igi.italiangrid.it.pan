structure template vo/params/igi.italiangrid.it;

'name' ?= 'igi.italiangrid.it';
'account_prefix' ?= 'igifun';

'voms_servers' ?= list(
    nlist('name', 'vomsmania.cnaf.infn.it',
          'host', 'vomsmania.cnaf.infn.it',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/igi.italiangrid.it/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 10267000;
