structure template vo/params/planck;

'name' ?= 'planck';
'account_prefix' ?= 'plarn';

'voms_servers' ?= list(
    dict('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'data base manager',
          'fqan', '/planck/Role=DBManager',
          'suffix', 'mrn',
          'suffix2', 'smnddbd',
         ),
    dict('description', 'SW manager',
          'fqan', '/planck/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 49000;
