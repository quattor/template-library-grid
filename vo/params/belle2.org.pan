structure template vo/params/belle2.org;

'name' ?= 'belle2.org';
'account_prefix' ?= 'belskj';

'voms_servers' ?= list(
    nlist('name', 'voms.cc.kek.jp',
          'host', 'voms.cc.kek.jp',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1891000;
