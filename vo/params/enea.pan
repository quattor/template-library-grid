structure template vo/params/enea;

'name' ?= 'enea';
'account_prefix' ?= 'enerl';

'voms_servers' ?= list(
    nlist('name', 'voms.cnaf.infn.it',
          'host', 'voms.cnaf.infn.it',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 47000;
