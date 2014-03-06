structure template vo/params/dca.euro-vo.org;

'name' ?= 'dca.euro-vo.org';
'account_prefix' ?= 'dcagf';

'voms_servers' ?= list(
    nlist('name', 'voms.esac.esa.int',
          'host', 'voms.esac.esa.int',
          'port', 15000,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 431000;
