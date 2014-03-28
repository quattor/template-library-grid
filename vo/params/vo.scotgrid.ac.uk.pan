structure template vo/params/vo.scotgrid.ac.uk;

'name' ?= 'vo.scotgrid.ac.uk';
'account_prefix' ?= 'scoiv';

'voms_servers' ?= list(
    nlist('name', 'svr029.gla.scotgrid.ac.uk',
          'host', 'svr029.gla.scotgrid.ac.uk',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 473000;
