structure template vo/params/vo.elixir-europe.org;

'name' ?= 'vo.elixir-europe.org';
'account_prefix' ?= 'elifyt';

'voms_servers' ?= list(
    nlist('name', 'voms1.grid.cesnet.cz',
          'host', 'voms1.grid.cesnet.cz',
          'port', 15032,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.grid.cesnet.cz',
          'host', 'voms2.grid.cesnet.cz',
          'port', 15032,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10351000;
