@{ deprecated machine-types only for gLite compatibility }
template machine-types/lb;

include { 
	deprecated(1,' machine-types/lb is deprecated, use machine-types/emi/lb instead');
	'machine-types/emi/lb';
};
