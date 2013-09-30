structure template vo/site/geant4;

# Fix for VO ID card errors. See https://gus.fzk.de/ws/ticket_info.php?ticket=65673
'voms_servers' ?= list(
    nlist('host', 'lcg-voms.cern.ch',
          'type', list('voms-only'),
         ),
    nlist('name', 'voms.cern.ch',
          'host', 'voms.cern.ch',
          'port', 15007,
          'adminport', 8443,
         ),
);

