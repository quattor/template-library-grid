structure template vo/params/vo.neugrid.eu;

'name' ?= 'vo.neugrid.eu';
'account_prefix' ?= 'neusns';

'voms_servers' ?= list(
    dict('name', 'voms.gnubila.fr',
          'host', 'voms.gnubila.fr',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.neugrid.eu/Role=sgmneugrid',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'Users of the development infrastructure',
          'fqan', '/vo.neugrid.eu/poc',
          'suffix', 'isns',
          'suffix2', 'txpil',
         ),
    dict('description', 'Users of the production infrastructure',
          'fqan', '/vo.neugrid.eu/prod',
          'suffix', 'jsns',
          'suffix2', 'todmas',
         ),
);

'base_uid' ?= 1952000;
