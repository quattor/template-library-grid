# Template to configure the log4j root logger.
# This is a structure template to allow to reuse this template for
# application specific loggers.

structure template common/tomcat5/root-logger;

'conf' = <<EOF;
# Possible levels: debug, info, warn, error, fatal.
# debug may produce a huge amount of output.
log4j.rootLogger=error, stdout
# Tomcat console is the main log file (normally /var/log/tomcat5/catalina.out)
log4j.appender.stdout=org.apache.log4j.ConsoleAppender
log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
log4j.appender.stdout.layout.ConversionPattern=%d{dd MMM yyyy HH:mm:ss,SSS} %-5p %-30.30c{1} %x - %m%n

EOF
