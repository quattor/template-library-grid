structure template vo/params/neiss.org.uk;

'name' ?= 'neiss.org.uk';
'account_prefix' ?= 'neifvv';

'voms_servers' ?= list(
    dict('name', 'voms.gridpp.ac.uk',
          'host', 'voms.gridpp.ac.uk',
          'port', 15027,
          'adminport', 8443,
         ),
    dict('name', 'voms02.gridpp.ac.uk',
          'host', 'voms02.gridpp.ac.uk',
          'port', 15027,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms03.gridpp.ac.uk',
          'host', 'voms03.gridpp.ac.uk',
          'port', 15027,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10275000;
