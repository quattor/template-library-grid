# This template does configuration related to use of CUDA on WNs

unique template common/cuda/config;

variable CUDA_INSTALL_DIR ?= error('CUDA installation path must be defined with variable CUDA_INSTALL_DIR');

# CUDA_INSTALL_DIR may be either a string defining the path to CUDA installatin, or a nlist with
# one entry per installed version. Key is the version name (escaped) and will be used uppercased for building the environment
# variable (CUDA_xxx_ROOT). In addition, one 'DEFAULT' entry may exists and will be used to define CUDA_ROOT variable. Its
# value may be either a path or the name (unescaped) of one of the other version defined.

include { 'components/profile/config' };
'/software/components/profile/env' = {
  if ( is_string(CUDA_INSTALL_DIR) ) {
    SELF['CUDA_ROOT'] = CUDA_INSTALL_DIR;
  } else if ( is_nlist(CUDA_INSTALL_DIR) ) {
    foreach (version_e;path;CUDA_INSTALL_DIR) {
      version = unescape(version_e);
      if ( version == 'DEFAULT' ) {
        if ( match(path,'^\s*/') ) {
          SELF['CUDA_ROOT'] = path;
        } else {
          path_e = escape(path);
          if ( exists(CUDA_INSTALL_DIR[path_e]) ) {
            SELF['CUDA_ROOT'] = CUDA_INSTALL_DIR[path_e];
          } else {
            error('Cuda version '+path+' not defined in CUDA_INSTALL_DIR');
          };
        };
      } else {
        SELF['CUDA_'+to_uppercase(unescape(version))+'_ROOT'] = path;
      };
    };
  } else {
    error('CUDA_INSTALL_DIR must be a string or nlist');
  };

  if ( length(SELF) > 0 ) {
    SELF;
  } else {
    null;
  };
};
