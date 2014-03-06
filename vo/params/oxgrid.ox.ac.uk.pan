structure template vo/params/oxgrid.ox.ac.uk;

'name' ?= 'oxgrid.ox.ac.uk';
'account_prefix' ?= 'oxgtwy';

'voms_servers' ?= list(
    nlist('name', 'voms.ngs.ac.uk',
          'host', 'voms.ngs.ac.uk',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2192000;
