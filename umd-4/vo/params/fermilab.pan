structure template vo/params/fermilab;

'name' ?= 'fermilab';
'account_prefix' ?= 'ferfwb';

'voms_servers' ?= list(
    dict('name', 'voms1.fnal.gov',
          'host', 'voms1.fnal.gov',
          'port', 15001,
          'adminport', 8443,
         ),
    dict('name', 'voms2.fnal.gov',
          'host', 'voms2.fnal.gov',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10307000;
