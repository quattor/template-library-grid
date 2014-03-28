structure template vo/params/seegrid;

'name' ?= 'seegrid';
'account_prefix' ?= 'seeha';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15040,
          'adminport', 8443,
         ),
    nlist('name', 'voms.irb.hr',
          'host', 'voms.irb.hr',
          'port', 15010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SAM testing',
          'fqan', '/seegrid/Role=ops',
          'suffix', 'hha',
          'suffix2', 'salwfei',
         ),
    nlist('description', 'SW manager',
          'fqan', '/seegrid/Role=sgmadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 452000;
