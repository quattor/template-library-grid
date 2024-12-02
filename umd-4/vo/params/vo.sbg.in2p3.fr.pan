structure template vo/params/vo.sbg.in2p3.fr;

'name' ?= 'vo.sbg.in2p3.fr';
'account_prefix' ?= 'sbgbp';

'voms_servers' ?= list(
    dict('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20006,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'Opened to users allowed to run Fluka code.',
          'fqan', '/vo.sbg.in2p3.fr/fluka',
          'suffix', 'mbp',
          'suffix2', 'uhbobrq',
         ),
    dict('description', 'For local users allowed to run MNCP code.',
          'fqan', '/vo.sbg.in2p3.fr/mcnp',
          'suffix', 'lbp',
          'suffix2', 'toxold',
         ),
);

'base_uid' ?= 311000;
