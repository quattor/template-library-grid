structure template vo/params/magic;

'name' ?= 'magic';
'account_prefix' ?= 'magf';

'voms_servers' ?= list(
    nlist('name', 'voms01.pic.es',
          'host', 'voms01.pic.es',
          'port', 15003,
          'adminport', 8443,
         ),
    nlist('name', 'voms02.pic.es',
          'host', 'voms02.pic.es',
          'port', 15003,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
);

'voms_mappings' ?= list(
#    nlist('description', 'SW manager',
#          'fqan', '/magic/Role=lcgadmin',
#          'suffix', 's',
#          'suffix2', 's',
#         ),
    nlist('description', 'Data analysis',
          'fqan', '/magic/Role=magicdata',
          'suffix', 'lf',
          'suffix2', 'dxesvlp',
         ),
    nlist('description', 'MC production',
          'fqan', '/magic/Role=magicmc',
          'suffix', 'jf',
          'suffix2', 'uzvzlbr',
         ),
    nlist('description', 'SW manager',
          'fqan', '/magic/Role=magicsoft',
          'suffix', 's',
          'suffix2', 's',
         ),
    nlist('description', 'production',
          'fqan', '/magic/montecarlo/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
    nlist('description', 'production',
          'fqan', '/magic/datacenter/Role=production',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 15000;
