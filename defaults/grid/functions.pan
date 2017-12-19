unique template defaults/grid/functions;

# Function to merge new tags with existing, removing duplicates.
# Accept a list of arguments that must be list of tags.
# Must be assigned to a variable containing the list to update.
# If argument is undef, do nothing.
function add_ce_runtime_env = {
  function_name = 'add_ce_runtime_env';
  if ( ARGC == 0 ) {
    error("Usage: "+function_name+"(tag_list[,tag_list...])");
  } else if ( !is_defined(ARGV[0]) ) {
    return(SELF);
  };

  tag_nlist = nlist(); 
  if ( is_list(SELF) ) {
    foreach(i;v;SELF) {
      tag_nlist[v] = '';
    };
  };
 
  arg_num = 0;
  while ( arg_num < ARGC ) {
    if ( is_list(ARGV[arg_num]) ) {
      new_tags_list = ARGV[arg_num];
    } else if ( is_string(ARGV[arg_num]) ) {
      new_tags_list = list(ARGV[arg_num]);
    } else if ( ! is_null(ARGV[arg_num]) ) {
      error(function_name+" : argument "+to_string(arg_num+1)+" must be a list or a string");
    };

    foreach (i;v;new_tags_list) {
      if ( !exists(tag_nlist[v]) ) {
        tag_nlist[v] = '';
      };
    };
    arg_num = arg_num + 1;
  };
  
  # Rewrite SELF list with tags in alphabetical order.
  # This is done by overwriting existing entries: the new list is at least
  # as long as the original one.
  tag_num = 0;
  foreach (k;v;tag_nlist) {
    SELF[tag_num] = k;
    tag_num = tag_num + 1;
  };

  SELF;
};
