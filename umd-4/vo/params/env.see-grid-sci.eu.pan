structure template vo/params/env.see-grid-sci.eu;

'name' ?= 'env.see-grid-sci.eu';
'account_prefix' ?= 'envsgs';

'voms_servers' ?= list(
    dict('name', 'voms.ipp.acad.bg',
          'host', 'voms.ipp.acad.bg',
          'port', 15001,
          'adminport', 8443,
         ),
);

'voms_mappings' ?= list(
);

'base_uid' ?= 1770000;
