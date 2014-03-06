# Template to configure the log4j glite-security-trustmanager logger.
# This configuration must be combined with the configuration of a root
# loggeri (eg. common/tomcat5/logger) to build a valid configuration.

structure template personality/cream_ce/trustmanager-logger;

'conf' = <<EOF;
# Possible levels: debug, info, warn, error, fatal.
# debug may produce a huge amount of output.
log4j.logger.org.glite.security=info, fileout

# the OUTPUT FILE for the logging messages
log4j.appender.fileout=org.apache.log4j.RollingFileAppender
log4j.appender.fileout.File=%%LOGFILE%%

# define max file size for the debug file
log4j.appender.fileout.MaxFileSize=2000KB

# Number of backup files
log4j.appender.fileout.MaxBackupIndex=10

# define the pattern of the messages
# use the closest format derived to the logging groups recommendation
log4j.appender.fileout.layout=org.apache.log4j.PatternLayout
log4j.appender.fileout.layout.ConversionPattern=tomcat [%t]: %d{yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ} %-5p %c{2} %x - %m%n
EOF
