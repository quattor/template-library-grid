structure template vo/params/kzvo.isragrid.org.il;

'name' ?= 'kzvo.isragrid.org.il';
'account_prefix' ?= 'kzvfvc';

'voms_servers' ?= list(
    dict('name', 'ngi-il-voms3.isragrid.org.il',
          'host', 'ngi-il-voms3.isragrid.org.il',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10282000;
