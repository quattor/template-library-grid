# RPMs specific to Oracle flavor of LFC

unique template glite/lfc/rpms/x86_64/oracle;

'/software/packages' = pkg_repl('LFC-server-oracle', '1.7.3-1sec.sl5', PKG_ARCH_GLITE);
'/software/packages' = pkg_repl('glite-LFC_oracle', '3.2.1-0', PKG_ARCH_GLITE);

'/software/packages' = pkg_repl('glite-info-provider-release','1.0.0-5','noarch');

'/software/packages' = if ( GLITE_UPDATE_VERSION >= '33' ) {
                         pkg_repl('glite-authz-pep-api-c','2.0.1-1.sl5','x86_64');
                       } else {
                         SELF;
                       };
