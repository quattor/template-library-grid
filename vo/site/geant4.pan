structure template vo/site/geant4;

# Fix for VO ID card errors. See https://gus.fzk.de/ws/ticket_info.php?ticket=65673
'voms_servers' ?= list(
    nlist('host', 'lcg-voms2.cern.ch',
          'type', list('voms-only'),
         ),
    nlist('name', 'voms2.cern.ch',
          'host', 'voms2.cern.ch',
          'port', 15007,
          'adminport', 8443,
         ),
);

