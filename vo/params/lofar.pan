structure template vo/params/lofar;

'name' ?= 'lofar';
'account_prefix' ?= 'lofzh';

'voms_servers' ?= list(
    nlist('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30019,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    nlist('description', 'cosmics group',
          'fqan', '/cosmics',
          'suffix', 'yzh',
          'suffix2', 'uszwzuo',
         ),
    nlist('description', 'eor group',
          'fqan', '/eor',
          'suffix', 'uzh',
          'suffix2', 'txasl',
         ),
    nlist('description', 'surveys group',
          'fqan', '/surveys',
          'suffix', 'uuzh',
          'suffix2', 'ynbhqae',
         ),
    nlist('description', 'transients group',
          'fqan', '/trans',
          'suffix', 'wzh',
          'suffix2', 'uieftzb',
         ),
    nlist('description', 'SW manager',
          'fqan', '/lofar/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/lofar/ops',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'production',
          'fqan', '/lofar/proc',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'Users group',
          'fqan', '/lofar/user',
          'suffix', 'bzh',
          'suffix2', 'tomzii',
         ),
);

'base_uid' ?= 251000;
