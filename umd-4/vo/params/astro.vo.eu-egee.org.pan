structure template vo/params/astro.vo.eu-egee.org;

'name' ?= 'astro.vo.eu-egee.org';
'account_prefix' ?= 'astgo';

'voms_servers' ?= list(
    dict('name', 'grid12.lal.in2p3.fr',
          'host', 'grid12.lal.in2p3.fr',
          'port', 20012,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 440000;
