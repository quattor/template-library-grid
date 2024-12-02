structure template vo/params/mpi-kickstart.egi.eu;

'name' ?= 'mpi-kickstart.egi.eu';
'account_prefix' ?= 'mpifug';

'voms_servers' ?= list(
    dict('name', 'voms1.egee.cesnet.cz',
          'host', 'voms1.egee.cesnet.cz',
          'port', 15030,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10260000;
