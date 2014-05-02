unique template features/java/config;

# ---------------------------------------------------------------------------- 
# profile
# ---------------------------------------------------------------------------- 
include { 'components/profile/config' };

# Setup path with java in it.
variable JAVA_LOCATION ?= '/usr/java/latest';
"/software/components/profile/path/PATH/append" = push(JAVA_LOCATION+"/bin");

# ---------------------------------------------------------------------------- 
# filecopy
# ---------------------------------------------------------------------------- 
include { 'components/filecopy/config' };

# Configure the java.conf files.

variable CONTENTS= <<EOF;
# File  maintained by Quattor ncm-filecopy. DO NOT EDIT.

export JAVA_LIBDIR=/usr/share/java
export JVM_ROOT=/usr/lib/jvm
#useless but required by build-jar-repository :
export JNI_LIBDIR=/usr/lib/java

EOF

variable CONTENTS= CONTENTS +  "export JAVA_HOME="+JAVA_LOCATION+"\n" ;


# Put this in two different locations (/etc and /etc/java).
"/software/components/filecopy/services" =
  npush(escape("/etc/java.conf"),
        nlist("config",CONTENTS,
              "perms","0755"));
"/software/components/filecopy/services" =
  npush(escape("/etc/java/java.conf"),
        nlist("config",CONTENTS,
              "perms","0755"));

