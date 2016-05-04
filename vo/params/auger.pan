structure template vo/params/auger;

'name' ?= 'auger';
'account_prefix' ?= 'augut';

'voms_servers' ?= list(
    nlist('name', 'voms1.egee.cesnet.cz',
          'host', 'voms1.egee.cesnet.cz',
          'port', 15004,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15004,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15004,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'auger FERMILAB users',
          'fqan', '/auger/FNAL',
          'suffix', 'but',
          'suffix2', 'tligtk',
         ),
    nlist('description', 'production',
          'fqan', '/auger/Role=Production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'SW manager',
          'fqan', '/auger/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 107000;
