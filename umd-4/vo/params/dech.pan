structure template vo/params/dech;

'name' ?= 'dech';
'account_prefix' ?= 'dectw';

'voms_servers' ?= list(
    dict('name', 'glite-io.scai.fraunhofer.de',
          'host', 'glite-io.scai.fraunhofer.de',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'Admin: VO administrators',
          'fqan', '/dech/Role=VO',
          'suffix', 'dtw',
          'suffix2', 'alnrocr',
         ),
    dict('description', 'SW manager',
          'fqan', '/dech/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 84000;
