structure template vo/params/vo.llr.in2p3.fr;

'name' ?= 'vo.llr.in2p3.fr';
'account_prefix' ?= 'llrfr';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 391000;
