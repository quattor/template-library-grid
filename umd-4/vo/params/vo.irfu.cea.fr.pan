structure template vo/params/vo.irfu.cea.fr;

'name' ?= 'vo.irfu.cea.fr';
'account_prefix' ?= 'irfjt';

'voms_servers' ?= list(
    dict('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20014,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 497000;
