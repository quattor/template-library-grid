unique template features/gsissh/client/config;

include { 'features/gsissh/client/rpms/config' };

# ---------------------------------------------------------------------------- 
# gsissh
# ---------------------------------------------------------------------------- 
include { 'components/gsissh/config' };

"/software/components/gsissh/globus_location" = GLOBUS_LOCATION;
"/software/components/gsissh/gpt_location" = INSTALL_ROOT+"/gpt";

# Configuration for the client.
"/software/components/gsissh/client/options" = nlist(
    "GssapiAuthentication", "yes",
    "GssapiKeyExchange", "yes",
    "GssapiDelegateCredentials", "yes",
);
