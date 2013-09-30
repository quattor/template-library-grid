# This template defines aliases for VO names

unique template vo/site/aliases;

# VOS_ALIASES is a nlist where key is the name used to refer to the VO (the alias)
# and the value is the real VO name (must match a template in vo/params).

variable VOS_ALIASES ?= nlist(
  'agata',	'vo.agata.org',
  'apc',	'vo.apc.univ-paris7.fr',
  'astro',	'astro.vo.eu-egee.org',
  'dapnia',	'vo.dapnia.cea.fr',
  'grif',	'vo.grif.fr',
  'ipno',	'vo.ipno.in2p3.fr',
  'irfu',	'vo.irfu.cea.fr',
  'lal',	'vo.lal.in2p3.fr',
  'lapp',	'vo.lapp.in2p3.fr',
  'llr',	'vo.llr.in2p3.fr',
  'lpnhe',	'vo.lpnhe.in2p3.fr',
  'psud',	'vo.u-psud.fr',
  'sbg',	'vo.sbg.in2p3.fr',
  'supernemo',	'supernemo.vo.eu-egee.org',
);
