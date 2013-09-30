structure template vo/params/nordugrid.org;

'name' ?= 'nordugrid.org';
'account_prefix' ?= 'norjz';

'voms_servers' ?= list(
    nlist('name', 'voms.ndgf.org',
          'host', 'voms.ndgf.org',
          'port', 15015,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 503000;
