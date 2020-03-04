#!/bin/bash

/usr/bin/find \
    /var/spool/arc/grid*/ \
    -name \* \
    -size +500M \
    -exec bash -c 'echo "The original output file for this job was too large. Excessively large output files can cause problems and are not appropriate for grid jobs. That file has been replaced by this one." > $1' _ {} \;
