# Helper functions to build Tomcat configuration

declaration template common/tomcat5/functions;

# Function to convert a value to a valid XML string.
# It accepts any value type that can be represented as a string (with to_string())
# and take care of replacing a few characters by their '&char;' representation.

function tomcat5_to_xml_string = {
  if ( ARGC != 1 ) {
    error(function_name+': requires exactly one argument ('+to_string(ARGC)+' passed).');
  };
  replace('&', '&amp;', to_string(ARGV[0]));
};
