unique template feature/accounting/apel/parser_blah;

# Add the base parser configuration for the LRMS used
# FIXME: add support for multiple LRMS.
variable APEL_PARSER_BASE_INCLUDE ?= 'feature/accounting/apel/parser_pbs';
include { APEL_PARSER_BASE_INCLUDE };

# Define where DGAS accounting records will be stored
variable GATEKEEPER_DGAS_DIR = BLAH_LOG_DIR;

# define APEL accounting processor, and undefine the GKLogProcessor (which becomes obsolete)
include { 'feature/accounting/apel/parser_pbs' };
"/software/components/apel/configFiles" = {
	blah_cfg= nlist (
		'SubmitHost', CE_HOST,
		'BlahdLogPrefix', "blahp.log-",
		'BlahdLogDir', list(GATEKEEPER_DGAS_DIR),
		'searchSubDirs', "yes",
		'reprocess', "no",
		);
	#define the Blah log processor
	SELF[escape(APEL_PARSER_CONFIG)]["BlahdLogProcessor"]=blah_cfg;
	#undefine the useless GKLogProcessor
	SELF[escape(APEL_PARSER_CONFIG)]["GKLogProcessor"] = null;
	SELF;
};
