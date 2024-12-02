structure template vo/params/vo.u-psud.fr;

'name' ?= 'vo.u-psud.fr';
'account_prefix' ?= 'upsrgi';

'voms_servers' ?= list(
    dict('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1110000;
