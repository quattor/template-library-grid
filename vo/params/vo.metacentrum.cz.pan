structure template vo/params/vo.metacentrum.cz;

'name' ?= 'vo.metacentrum.cz';
'account_prefix' ?= 'mettri';

'voms_servers' ?= list(
    nlist('name', 'voms1.egee.cesnet.cz',
          'host', 'voms1.egee.cesnet.cz',
          'port', 15007,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 2072000;
