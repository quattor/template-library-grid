structure template vo/params/vo.sixt.cern.ch;

'name' ?= 'vo.sixt.cern.ch';
'account_prefix' ?= 'sixc';

'voms_servers' ?= list(
    dict('name', 'voms.cern.ch',
          'host', 'voms.cern.ch',
          'port', 15005,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/vo.sixt.cern.ch/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 12000;
