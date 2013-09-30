# RPMs specific to Oracle VOMS version.
# Based on VOMS 3.1.4 official RPM list.

unique template glite/voms/rpms/i386/oracle;
 
'/software/packages' = pkg_repl('glite-VOMS_oracle', '3.1.4-0', 'i386');
'/software/packages' = pkg_repl('glite-security-voms-oracle', '2.0.11-3.slc4', 'i386');
