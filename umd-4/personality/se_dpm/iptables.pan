unique template personality/se_dpm/iptables;

include 'components/iptables/config';

"/software/components/iptables/filter/rules" = {
    rules = list();
    if ( !is_null(DPM_IPTABLES_INCLUDE) ) {
        rules = merge(rules, DPM_IPTABLES_RULES);
    };
    if ( length(rules) > 0 ) {
        rules;
    } else {
        null;
    };
};

