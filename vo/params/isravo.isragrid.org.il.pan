structure template vo/params/isravo.isragrid.org.il;

'name' ?= 'isravo.isragrid.org.il';
'account_prefix' ?= 'isrfvy';

'voms_servers' ?= list(
    dict('name', 'ngi-il-voms3.isragrid.org.il',
          'host', 'ngi-il-voms3.isragrid.org.il',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10278000;
