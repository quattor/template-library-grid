structure template vo/params/eo-grid.ikd.kiev.ua;

'name' ?= 'eo-grid.ikd.kiev.ua';
'account_prefix' ?= 'eogscw';

'voms_servers' ?= list(
    nlist('name', 'grid.org.ua',
          'host', 'grid.org.ua',
          'port', 15002,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    nlist('name', 'voms.grid.ikd.kiev.ua',
          'host', 'voms.grid.ikd.kiev.ua',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1670000;
