structure template vo/params/vo.sn2ns.in2p3.fr;

'name' ?= 'vo.sn2ns.in2p3.fr';
'account_prefix' ?= 'sn2fuv';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20019,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10249000;
