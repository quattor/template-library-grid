structure template vo/params/cdf;

'name' ?= 'cdf';
'account_prefix' ?= 'cdfy';

'voms_servers' ?= list(
    dict('name', 'voms-01.pd.infn.it',
          'host', 'voms-01.pd.infn.it',
          'port', 15001,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15001,
          'adminport', 8443,
         ),
    dict('name', 'voms.fnal.gov',
          'host', 'voms.fnal.gov',
          'port', 15020,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 8000;
