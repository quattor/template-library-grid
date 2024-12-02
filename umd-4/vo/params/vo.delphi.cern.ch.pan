structure template vo/params/vo.delphi.cern.ch;

'name' ?= 'vo.delphi.cern.ch';
'account_prefix' ?= 'delszo';

'voms_servers' ?= list(
    dict('name', 'voms.cern.ch',
          'host', 'voms.cern.ch',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'production',
          'fqan', '/vo.delphi.cern.ch/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'SW manager',
          'fqan', '/vo.delphi.cern.ch/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1610000;
