structure template vo/params/bioinfo.twgrid.org;

'name' ?= 'bioinfo.twgrid.org';
'account_prefix' ?= 'biofyk';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sinica.edu.tw',
          'host', 'voms.grid.sinica.edu.tw',
          'port', 15017,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10368000;
