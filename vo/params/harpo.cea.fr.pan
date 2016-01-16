structure template vo/params/harpo.cea.fr;

'name' ?= 'harpo.cea.fr';
'account_prefix' ?= 'hrp';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20024,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10278000;
