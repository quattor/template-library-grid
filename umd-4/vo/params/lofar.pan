structure template vo/params/lofar;

'name' ?= 'lofar';
'account_prefix' ?= 'lofzh';

'voms_servers' ?= list(
    dict('name', 'voms.grid.sara.nl',
          'host', 'voms.grid.sara.nl',
          'port', 30019,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'cosmics group',
          'fqan', '/cosmics',
          'suffix', 'yzh',
          'suffix2', 'uszwzuo',
         ),
    dict('description', 'eor group',
          'fqan', '/eor',
          'suffix', 'uzh',
          'suffix2', 'txasl',
         ),
    dict('description', 'surveys group',
          'fqan', '/surveys',
          'suffix', 'uuzh',
          'suffix2', 'ynbhqae',
         ),
    dict('description', 'transients group',
          'fqan', '/trans',
          'suffix', 'wzh',
          'suffix2', 'uieftzb',
         ),
    dict('description', 'SW manager',
          'fqan', '/lofar/Role=lcgadmin',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/lofar/ops',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'production',
          'fqan', '/lofar/proc',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'Users group',
          'fqan', '/lofar/user',
          'suffix', 'bzh',
          'suffix2', 'tomzii',
         ),
);

'base_uid' ?= 251000;
