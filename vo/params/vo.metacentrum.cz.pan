structure template vo/params/vo.metacentrum.cz;

'name' ?= 'vo.metacentrum.cz';
'account_prefix' ?= 'mettri';

'voms_servers' ?= list(
    nlist('name', 'voms1.egee.cesnet.cz',
          'host', 'voms1.egee.cesnet.cz',
          'port', 15020,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2072000;
