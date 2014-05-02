
unique template feature/ldconf/config;

# Since Glite 3.1 update 9, all components release in 64-bit have their shared
# libraries placed in lib64 instead of lib 
variable LDCONF_ARCH_DIR = if (PKG_ARCH_GLITE == 'x86_64') {
                             return('lib64');
                           } else {
                             return('lib');
                           };

# ---------------------------------------------------------------------------- 
# ldconf
# ---------------------------------------------------------------------------- 
include { 'components/ldconf/config' };

"/software/components/ldconf/paths" = push(GLOBUS_LOCATION+"/lib");
