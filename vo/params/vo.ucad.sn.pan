structure template vo/params/vo.ucad.sn;

'name' ?= 'vo.ucad.sn';
'account_prefix' ?= 'ucartg';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20015,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 770000;
