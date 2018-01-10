
unique template users/infosys;

# -----------------------------------------------------------------------------
# infosys is a group shared by all accounts collecting information
# -----------------------------------------------------------------------------
include { 'components/accounts/config' };

"/software/components/accounts/groups/infosys" =
  nlist("gid", 997);


