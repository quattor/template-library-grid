unique template vo/params/allvos;

variable ALLVOS ?= list(
        'aegis',
        'afigrid.cl',
        'alice',
        'ams02.cern.ch',
        'apesci',
        'argo',
        'armgrid.grid.am',
        'astro.vo.eu-egee.org',
        'astron',
        'atlas',
        'atlas.ac.il',
        'auger',
        'auvergrid',
        'balticgrid',
        'bbmri.nl',
        'belle',
        'belle2.org',
        'bg-edu.grid.acad.bg',
        'bing.vo.ibergrid.eu',
        'bioinfo.twgrid.org',
        'biomed',
        'calet.org',
        'calice',
        'camont',
        'cdf',
        'cernatschool.org',
        'cesga',
        'chem.vo.ibergrid.eu',
        'chipster.csc.fi',
        'cic.testworkflow.fr',
        'cms',
        'comet.j-parc.jp',
        'compchem',
        'comput-er.it',
        'd4science.org',
        'dech',
        'demo.fedcloud.egi.eu',
        'desktopgrid.vo.edges-grid.eu',
        'desy',
        'dream.hipcat.net',
        'drihm.eu',
        'dteam',
        'dzero',
        'earth.vo.ibergrid.eu',
        'edteam',
        'eela',
        'egeode',
        'eiscat.se',
        'eli-beams.eu',
        'eli-np.eu',
        'enea',
        'eng.vo.ibergrid.eu',
        'enmr.eu',
        'env.see-grid-sci.eu',
        'envirogrids.vo.eu-egee.org',
        'eo-grid.ikd.kiev.ua',
        'epic.vo.gridpp.ac.uk',
        'esr',
        'euasia.euasiagrid.org',
        'eubrazilcc.eu',
        'euchina',
        'euindia',
        'eumed',
        'extras-fp7.eu',
        'fedcloud.egi.eu',
        'fermilab',
        'fusion',
        'gaussian',
        'geant4',
        'geohazards.terradue.com',
        'gerda.mpg.de',
        'ghep',
        'gilda',
        'glast.org',
        'gr-sim.grid.auth.gr',
        'gridifin.ro',
        'gridit',
        'gridpp',
        'harpo.cea.fr',
        'hermes',
        'hgdemo',
        'highthroughputseq.egi.eu',
        'hone',
        'hungrid',
        'hydrology.terradue.com',
        'hyperk.org',
        'iber.vo.ibergrid.eu',
        'icarus-exp.org',
        'icecube',
        'ict.vo.ibergrid.eu',
        'ific',
        'ilc',
        'ildg',
        'imath.cesga.es',
        'inaf',
        'infngrid',
        'ipv6.hepix.org',
        'israelvo.isragrid.org.il',
        'isravo.isragrid.org.il',
        'juno.ihep.ac.cn',
        'km3net.org',
        'kzvo.isragrid.org.il',
        'lagoproject.org',
        'lattice.itep.ru',
        'lhcb',
        'life.vo.ibergrid.eu',
        'lofar',
        'lsgrid',
        'lsst',
        'lz',
        'magic',
        'mice',
        'moldyngrid',
        'mpi-kickstart.egi.eu',
        'na62.vo.gridpp.ac.uk',
        'neiss.org.uk',
        'net.egi.eu',
        'neurogrid.incf.org',
        'nordugrid.org',
        'nw_ru',
        'oper.vo.eu-eela.eu',
        'ops',
        'ops.ndgf.org',
        'ops.vo.ibergrid.eu',
        'oxgrid.ox.ac.uk',
        'pacs.infn.it',
        'pamela',
        'peachnote.com',
        'pheno',
        'phys.vo.ibergrid.eu',
        'physiome.lf1.cuni.cz',
        'planck',
        'proactive',
        'prod.vo.eu-eela.eu',
        'projects.nl',
        'pvier',
        'ronbio.ro',
        'sagrid.ac.za',
        'see',
        'seismo.see-grid-sci.eu',
        'snoplus.snolab.ca',
        'social.vo.ibergrid.eu',
        'superbvo.org',
        'supernemo.vo.eu-egee.org',
        'swetest',
        't2k.org',
        'theophys',
        'training.egi.eu',
        'trgrida',
        'trgridb',
        'trgridd',
        'trgride',
        'tut.vo.ibergrid.eu',
        'twgrid',
        'ukmhd.ac.uk',
        'ukqcd',
        'uniandes.edu.co',
        'uscms',
        'verce.eu',
        'virgo',
        'vlemed',
        'vo.access.egi.eu',
        'vo.africa-grid.org',
        'vo.agata.org',
        'vo.aginfra.eu',
        'vo.aleph.cern.ch',
        'vo.apc.univ-paris7.fr',
        'vo.astro.pic.es',
        'vo.chain-project.eu',
        'vo.cictest.fr',
        'vo.compass.cern.ch',
        'vo.complex-systems.eu',
        'vo.cs.br',
        'vo.cta.in2p3.fr',
        'vo.dariah.eu',
        'vo.dch-rp.eu',
        'vo.delphi.cern.ch',
        'vo.dirac.ac.uk',
        'vo.earthserver.eu',
        'vo.elixir-europe.org',
        'vo.eu-decide.eu',
        'vo.formation.idgrilles.fr',
        'vo.france-asia.org',
        'vo.france-grilles.fr',
        'vo.gear.cern.ch',
        'vo.general.csic.es',
        'vo.grand-est.fr',
        'vo.grid.auth.gr',
        'vo.gridcl.fr',
        'vo.grif.fr',
        'vo.helio-vo.eu',
        'vo.hess-experiment.eu',
        'vo.ifisc.csic.es',
        'vo.indicate-project.eu',
        'vo.indigo-datacloud.eu',
        'vo.ingv.it',
        'vo.ipnl.in2p3.fr',
        'vo.ipno.in2p3.fr',
        'vo.irfu.cea.fr',
        'vo.lal.in2p3.fr',
        'vo.landslides.mossaic.org',
        'vo.lapp.in2p3.fr',
        'vo.lifewatch.eu',
        'vo.llr.in2p3.fr',
        'vo.londongrid.ac.uk',
        'vo.lpnhe.in2p3.fr',
        'vo.lpsc.in2p3.fr',
        'vo.magrid.ma',
        'vo.mcia.fr',
        'vo.metacentrum.cz',
        'vo.moedal.org',
        'vo.msfg.fr',
        'vo.mure.in2p3.fr',
        'vo.nbis.se',
        'vo.neugrid.eu',
        'vo.northgrid.ac.uk',
        'vo.ops.csic.es',
        'vo.panda.gsi.de',
        'vo.paus.pic.es',
        'vo.pic.es',
        'vo.plgrid.pl',
        'vo.renabi.fr',
        'vo.rhone-alpes.idgrilles.fr',
        'vo.sbg.in2p3.fr',
        'vo.scotgrid.ac.uk',
        'vo.sim-e-child.org',
        'vo.sixt.cern.ch',
        'vo.sn2ns.in2p3.fr',
        'vo.southgrid.ac.uk',
        'vo.turbo.pic.es',
        'vo.u-psud.fr',
        'vo.up.pt',
        'voce',
        'xenon.biggrid.nl',
        'xfel.eu',
        'zeus',
);

