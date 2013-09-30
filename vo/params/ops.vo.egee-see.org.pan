structure template vo/params/ops.vo.egee-see.org;

'name' ?= 'ops.vo.egee-see.org';
'account_prefix' ?= 'opssqi';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.auth.gr',
          'host', 'voms.grid.auth.gr',
          'port', 15120,
          'adminport', 8443,
         ),
    nlist('name', 'voms.ipb.ac.rs',
          'host', 'voms.ipb.ac.rs',
          'port', 15004,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1370000;
