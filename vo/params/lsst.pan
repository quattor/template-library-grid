structure template vo/params/lsst;

'name' ?= 'lsst';
'account_prefix' ?= 'lssfvb';

'voms_servers' ?= list(
    dict('name', 'voms.fnal.gov',
          'host', 'voms.fnal.gov',
          'port', 15003,
          'adminport', 8443,
         ),
    dict('name', 'voms1.fnal.gov',
          'host', 'voms1.fnal.gov',
          'port', 15003,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms2.fnal.gov',
          'host', 'voms2.fnal.gov',
          'port', 15003,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10281000;
