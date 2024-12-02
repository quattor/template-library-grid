structure template vo/params/euchina;

'name' ?= 'euchina';
'account_prefix' ?= 'eucur';

'voms_servers' ?= list(
    dict('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15017,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 105000;
