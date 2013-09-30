structure template vo/params/vo.lpnhe.in2p3.fr;

'name' ?= 'vo.lpnhe.in2p3.fr';
'account_prefix' ?= 'lpnfl';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20008,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 411000;
