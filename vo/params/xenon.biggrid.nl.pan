structure template vo/params/xenon.biggrid.nl;

'name' ?= 'xenon.biggrid.nl';
'account_prefix' ?= 'xenfuy';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30008,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/xenon.biggrid.nl/Role=sgm',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 10252000;
