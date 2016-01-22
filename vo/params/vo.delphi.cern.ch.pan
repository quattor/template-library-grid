structure template vo/params/vo.delphi.cern.ch;

'name' ?= 'vo.delphi.cern.ch';
'account_prefix' ?= 'delszo';

'voms_servers' ?= list(
    nlist('name', 'lcg-voms2.cern.ch',
          'host', 'lcg-voms2.cern.ch',
          'port', 15002,
          'adminport', 8443,
         ),
    nlist('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'production',
          'fqan', '/vo.delphi.cern.ch/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'SW manager',
          'fqan', '/vo.delphi.cern.ch/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
);

'base_uid' ?= 1610000;
