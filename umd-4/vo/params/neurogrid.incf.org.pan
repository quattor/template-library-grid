structure template vo/params/neurogrid.incf.org;

'name' ?= 'neurogrid.incf.org';
'account_prefix' ?= 'neufvr';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15025,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10271000;
