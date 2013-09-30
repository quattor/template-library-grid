structure template vo/params/israelvo.isragrid.org.il;

'name' ?= 'israelvo.isragrid.org.il';
'account_prefix' ?= 'isrfuf';

'voms_servers' ?= list(
    nlist('name', 'ngi-il-voms1.isragrid.org.il',
          'host', 'ngi-il-voms1.isragrid.org.il',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10259000;
