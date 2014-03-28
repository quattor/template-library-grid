structure template vo/params/vo.aleph.cern.ch;

'name' ?= 'vo.aleph.cern.ch';
'account_prefix' ?= 'aletig';

'voms_servers' ?= list(
    nlist('name', 'voms-admin.cern.ch',
          'host', 'voms-admin.cern.ch',
          'port', 15013,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2512000;
