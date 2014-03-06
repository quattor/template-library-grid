structure template vo/params/vo.hess-experiment.eu;

'name' ?= 'vo.hess-experiment.eu';
'account_prefix' ?= 'heslo';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20021,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'SW manager',
          'fqan', '/vo.hess-experiment.eu/Role=swadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 570000;
