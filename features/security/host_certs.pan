
unique template features/security/host_certs;

# ---------------------------------------------------------------------------- 
# dirperm
# ---------------------------------------------------------------------------- 
include { 'components/dirperm/config' };

"/software/components/dirperm/paths" =
  push(
    nlist(
      "path", SITE_DEF_HOST_KEY,
      "owner", "root:root",
      "perm", "0400",
      "type", "f")
  );

"/software/components/dirperm/paths" =
  push(
    nlist(
      "path", SITE_DEF_HOST_CERT,
      "owner", "root:root",
      "perm", "0644",
      "type", "f"),
  );
