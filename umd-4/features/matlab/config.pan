# This template does configuration related to use of MatLab on WNs

unique template features/matlab/config;

variable MATLAB_INSTALL_DIR ?= error('MatLab installation path must be defined with variable MATLAB_INSTALL_DIR');

# MATLAB_INSTALL_DIR may be either a string defining the path to MatLab installatin, or a nlist with
# one entry per installed version. Key is the version name (escaped) and will be used uppercased for building the environment
# variable (MATLAB_xxx_ROOT). In addition, one 'DEFAULT' entry may exists and will be used to define MATLAB_ROOT variable. Its
# value may be either a path or the name (unescaped) of one of the other version defined.

include { 'components/profile/config' };
'/software/components/profile/env' = {
  if ( is_string(MATLAB_INSTALL_DIR) ) {
    SELF['MATLAB_ROOT'] = MATLAB_INSTALL_DIR;
  } else if ( is_nlist(MATLAB_INSTALL_DIR) ) {
    foreach (version_e;path;MATLAB_INSTALL_DIR) {
      version = unescape(version_e);
      if ( version == 'DEFAULT' ) {
        if ( match(path,'^\s*/') ) {
          SELF['MATLAB_ROOT'] = path;
        } else {
          path_e = escape(path);
          if ( exists(MATLAB_INSTALL_DIR[path_e]) ) {
            SELF['MATLAB_ROOT'] = MATLAB_INSTALL_DIR[path_e];
          } else {
            error('MatLab version '+path+' not defined in MATLAB_INSTALL_DIR');
          };
        };
      } else {
        SELF['MATLAB_'+to_uppercase(unescape(version))+'_ROOT'] = path;
      };
    };
  } else {
    error('MATLAB_INSTALL_DIR must be a string or nlist');
  };

  if ( length(SELF) > 0 ) {
    SELF;
  } else {
    null;
  };
};
