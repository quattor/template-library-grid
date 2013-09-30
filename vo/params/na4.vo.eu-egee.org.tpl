structure template vo/params/na4.vo.eu-egee.org;

'name' ?= 'na4.vo.eu-egee.org';
'account_prefix' ?= 'na4pq';

'voms_servers' ?= list(
    nlist('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20016,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 650000;
