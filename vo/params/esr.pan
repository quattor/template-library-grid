structure template vo/params/esr;

'name' ?= 'esr';
'account_prefix' ?= 'esrv';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/esr/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'protecting files originating from ESA',
          'fqan', '/esr/eobs',
          'suffix', 'zv',
          'suffix2', 'tnlqka',
         ),
    nlist('description', 'protecting ecmwf data',
          'fqan', '/esr/eobs/ecmwf',
          'suffix', 'fv',
          'suffix2', 'crjmmrx',
         ),
    nlist('description', 'protect source code for SpecFEM3D software',
          'fqan', '/esr/specfem',
          'suffix', 'cv',
          'suffix2', 'yaynzcg',
         ),
);

'base_uid' ?= 5000;
