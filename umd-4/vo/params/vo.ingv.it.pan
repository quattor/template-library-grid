structure template vo/params/vo.ingv.it;

'name' ?= 'vo.ingv.it';
'account_prefix' ?= 'ingfup';

'voms_servers' ?= list(
    dict('name', 'vomsmania.cnaf.infn.it',
          'host', 'vomsmania.cnaf.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10269000;
