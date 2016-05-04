structure template vo/params/eiscat.se;

'name' ?= 'eiscat.se';
'account_prefix' ?= 'eisfvk';

'voms_servers' ?= list(
    nlist('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15005,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10290000;
