unique template personality/se_dpm/rpms/memcached;

'/software/packages' = {
  pkg_repl('memcached');
  pkg_repl('dmlite-plugins-memcache');
  SELF;
};
