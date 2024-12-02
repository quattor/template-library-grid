unique template features/memcached/schema;

type memcached_sysconfig_keys = {
  'CACHESIZE' ? long
  'MAXCONN' ? long
  # OPTIONS if present is almost certainly with multiple words: ensure it is quoted
  'OPTIONS' ? string with (length(SELF) == 0) || match(SELF,'^".*"$') || match(SELF,"^'.*'$")
  'PORT' ? long
  'USER' ? string
};
