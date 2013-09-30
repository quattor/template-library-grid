structure template vo/params/geclipse;

'name' ?= 'geclipse';
'account_prefix' ?= 'gecty';

'voms_servers' ?= list(
    nlist('name', 'dgrid-voms.fzk.de',
          'host', 'dgrid-voms.fzk.de',
          'port', 15009,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 86000;
