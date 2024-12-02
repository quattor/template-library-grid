structure template vo/params/magic;

'name' ?= 'magic';
'account_prefix' ?= 'magf';

'voms_servers' ?= list(
    dict('name', 'voms01.pic.es',
          'host', 'voms01.pic.es',
          'port', 15003,
          'adminport', 8443,
         ),
    dict('name', 'voms02.pic.es',
          'host', 'voms02.pic.es',
          'port', 15003,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    dict('description', 'SW manager',
#          'fqan', '/magic/Role=lcgadmin',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
    dict('description', 'Data analysis',
          'fqan', '/magic/Role=magicdata',
          'suffix', 'lf',
          'suffix2', 'dxesvlp',
         ),
    dict('description', 'MC production',
          'fqan', '/magic/Role=magicmc',
          'suffix', 'jf',
          'suffix2', 'uzvzlbr',
         ),
    dict('description', 'SW manager',
          'fqan', '/magic/Role=magicsoft',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/magic/montecarlo/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    dict('description', 'production',
          'fqan', '/magic/datacenter/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 15000;
