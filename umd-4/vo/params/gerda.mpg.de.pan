structure template vo/params/gerda.mpg.de;

'name' ?= 'gerda.mpg.de';
'account_prefix' ?= 'gerful';

'voms_servers' ?= list(
    dict('name', 'vomsIGI-NA.unina.it',
          'host', 'vomsIGI-NA.unina.it',
          'port', 15002,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'vomsmania.cnaf.infn.it',
          'host', 'vomsmania.cnaf.infn.it',
          'port', 15002,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 10265000;
