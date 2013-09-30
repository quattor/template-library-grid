structure template vo/params/geclipsetutor;

'name' ?= 'geclipsetutor';
'account_prefix' ?= 'gecjw';

'voms_servers' ?= list(
    nlist('name', 'dgrid-voms.fzk.de',
          'host', 'dgrid-voms.fzk.de',
          'port', 15007,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 500000;
