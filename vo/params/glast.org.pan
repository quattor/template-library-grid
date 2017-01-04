structure template vo/params/glast.org;

'name' ?= 'glast.org';
'account_prefix' ?= 'glarvu';

'voms_servers' ?= list(
    dict('name', 'voms-02.pd.infn.it',
          'host', 'voms-02.pd.infn.it',
          'port', 15018,
          'adminport', 8443,
          'type', list('voms-only'),
         ),
    dict('name', 'voms2.cnaf.infn.it',
          'host', 'voms2.cnaf.infn.it',
          'port', 15018,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
    dict('description', 'SW manager',
          'fqan', '/glast.org/Role=SoftwareManager',
          'suffix', 's',
          'suffix2', 's',
         ),
    dict('description', 'production',
          'fqan', '/glast.org/Role=prod',
          'suffix', 'p',
          'suffix2', 'p',
         ),
);

'base_uid' ?= 810000;
