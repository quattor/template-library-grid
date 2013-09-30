structure template vo/params/vo.apc.univ-paris7.fr;

'name' ?= 'vo.apc.univ-paris7.fr';
'account_prefix' ?= 'apcgl';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20010,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 437000;
