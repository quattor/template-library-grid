structure template vo/params/projects.nl;

'name' ?= 'projects.nl';
'account_prefix' ?= 'profvh';

'voms_servers' ?= list(
    dict('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30028,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10287000;
