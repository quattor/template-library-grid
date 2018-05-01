unique template personality/lfc/iptables;

include 'components/iptables/config';

"/software/components/iptables/filter/rules" = {
    rules = list();
    if ( !is_null(LFC_IPTABLES_INCLUDE) ) {
        rules = merge(rules, LFC_IPTABLES_RULES);
    };
    if ( length(rules) > 0 ) {
        rules;
    } else {
        null;
    };
};

