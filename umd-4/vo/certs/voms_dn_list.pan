unique template vo/certs/voms_dn_list;

variable VOMS_SERVER_DN ?= list(
    'cclcgvomsli01.in2p3.fr',       dict('subject', '/O=GRID-FR/C=FR/O=CNRS/OU=CC-IN2P3/CN=cclcgvomsli01.in2p3.fr',
                                          'issuer', '/C=FR/O=CNRS/CN=GRID2-FR',
                                         ),
    'eubrazilcc-voms.i3m.upv.es',   dict('subject', '/DC=es/DC=irisgrid/O=upv/CN=host/eubrazilcc-voms.i3m.upv.es',
                                          'issuer', '/DC=es/DC=irisgrid/CN=IRISGridCA',
                                         ),
    'glite-io.scai.fraunhofer.de',  dict('subject', '/C=DE/O=GermanGrid/OU=Fraunhofer SCAI/CN=host/glite-io.scai.fraunhofer.de',
                                          'issuer', '/C=DE/O=GermanGrid/CN=GridKa-CA',
                                         ),
    'grid-voms.desy.de',            dict('subject', '/C=DE/O=GermanGrid/OU=DESY/CN=host/grid-voms.desy.de',
                                          'issuer', '/C=DE/O=GermanGrid/CN=GridKa-CA',
                                         ),
    'grid11.kfki.hu',               dict('subject', '/C=HU/O=NIIF CA/OU=GRID/OU=KFKI/CN=grid11.kfki.hu',
                                          'issuer', '/C=HU/O=NIIF/OU=Certificate Authorities/CN=NIIF Root CA 2',
                                         ),
    'grid12.lal.in2p3.fr',          dict('subject', '/O=GRID-FR/C=FR/O=CNRS/OU=LAL/CN=grid12.lal.in2p3.fr',
                                          'issuer', '/C=FR/O=CNRS/CN=GRID2-FR',
                                         ),
    'gt1.pnpi.nw.ru',               dict('subject', '/C=RU/O=RDIG/OU=hosts/OU=pnpi.nw.ru/CN=gt1.pnpi.nw.ru',
                                          'issuer', '/C=RU/O=RDIG/CN=Russian Data-Intensive Grid CA',
                                         ),
    'ibergrid-voms.ifca.es',        dict('subject', '/DC=es/DC=irisgrid/O=ifca/CN=host/ibergrid-voms.ifca.es',
                                          'issuer', '/DC=es/DC=irisgrid/CN=IRISGridCA',
                                         ),
    'lcg-voms2.cern.ch',            dict('subject', '/DC=ch/DC=cern/OU=computers/CN=lcg-voms2.cern.ch',
                                          'issuer', '/DC=ch/DC=cern/CN=CERN Grid Certification Authority',
                                         ),
    'swevo.ific.uv.es',             dict('subject', '/DC=es/DC=irisgrid/O=ific/CN=swevo.ific.uv.es',
                                          'issuer', '/DC=es/DC=irisgrid/CN=IRISGridCA',
                                         ),
    'tbit02.nipne.ro',              dict('subject', '/DC=RO/DC=RomanianGRID/O=IFIN-HH/CN=tbit02.nipne.ro',
                                          'issuer', '/DC=RO/DC=RomanianGRID/O=ROSA/OU=Certification Authority/CN=RomanianGRID CA',
                                         ),
    'verce-voms.scai.fraunhofer.de', dict('subject', '/C=DE/O=GermanGrid/OU=Fraunhofer SCAI/CN=verce-voms.scai.fraunhofer.de',
                                          'issuer', '/C=DE/O=GermanGrid/CN=GridKa-CA',
                                         ),
    'voms-01.pd.infn.it',           dict('subject', '/C=IT/O=INFN/OU=Host/L=Padova/CN=voms-01.pd.infn.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN Certification Authority',
                                         ),
    'voms-02.pd.infn.it',           dict('subject', '/C=IT/O=INFN/OU=Host/L=Padova/CN=voms-02.pd.infn.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN Certification Authority',
                                         ),
    'voms-eela.ceta-ciemat.es',     dict('subject', '/DC=es/DC=irisgrid/O=ceta-ciemat/CN=host/voms-eela.ceta-ciemat.es',
                                          'issuer', '/DC=es/DC=irisgrid/CN=IRISGridCA',
                                         ),
    'voms-prg.bifi.unizar.es',      dict('subject', '/DC=es/DC=irisgrid/O=bifi-unizar/CN=voms-prg.bifi.unizar.es',
                                          'issuer', '/DC=es/DC=irisgrid/CN=IRISGridCA',
                                         ),
    'voms.ba.infn.it',              dict('subject', '/DC=org/DC=terena/DC=tcs/C=IT/ST=Rome/L=Frascati/O=Istituto Nazionale di Fisica Nucleare/CN=voms.ba.infn.it',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms.balticgrid.org',          dict('subject', '/DC=org/DC=terena/DC=tcs/C=EE/ST=Tartumaa/L=Tartu/O=EENet/CN=voms.balticgrid.org',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms.cat.cbpf.br',             dict('subject', '/C=BR/O=ICPEDU/O=UFF BrGrid CA/O=CBPF/OU=LAFEX/CN=host/voms.cat.cbpf.br',
                                          'issuer', '/C=BR/O=ICPEDU/O=UFF BrGrid CA/CN=UFF Brazilian Grid Certification Authority',
                                         ),
    'voms.cc.kek.jp',               dict('subject', '/C=JP/O=KEK/OU=CRC/CN=host/voms.cc.kek.jp',
                                          'issuer', '/C=JP/O=KEK/OU=CRC/CN=KEK GRID Certificate Authority',
                                         ),
    'voms.ciemat.es',               dict('subject', '/DC=es/DC=irisgrid/O=ciemat/CN=voms.ciemat.es',
                                          'issuer', '/DC=es/DC=irisgrid/CN=IRISGridCA',
                                         ),
    'voms.cnaf.infn.it',            dict('subject', '/C=IT/O=INFN/OU=Host/L=CNAF/CN=voms.cnaf.infn.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN Certification Authority',
                                         ),
    'voms.ct.infn.it',              dict('subject', '/C=IT/O=INFN/OU=Host/L=Catania/CN=voms.ct.infn.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN CA',
                                         ),
    'voms.cyf-kr.edu.pl',           dict('subject', '/C=PL/O=GRID/O=Cyfronet/CN=voms.cyf-kr.edu.pl',
                                          'issuer', '/C=PL/O=GRID/CN=Polish Grid CA',
                                         ),
    'voms.egi.cesga.es',            dict('subject', '/DC=es/DC=irisgrid/O=cesga/CN=host/voms.egi.cesga.es',
                                          'issuer', '/DC=es/DC=irisgrid/CN=IRISGridCA',
                                         ),
    'voms.fgi.csc.fi',              dict('subject', '/O=Grid/O=NorduGrid/CN=host/voms.fgi.csc.fi',
                                          'issuer', '/O=Grid/O=NorduGrid/CN=NorduGrid Certification Authority 2015',
                                         ),
    'voms.fis.puc.cl',              dict('subject', '/C=CL/O=REUNACA/O=REUNA/OU=PUC/CN=voms.fis.puc.cl',
                                          'issuer', '/C=CL/O=REUNACA/CN=REUNA Certification Authority',
                                         ),
    'voms.fnal.gov',                dict('subject', '/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=voms2.fnal.gov',
                                          'issuer', '/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1',
                                         ),
    'voms.gnubila.fr',              dict('subject', '/O=GRID-FR/C=FR/O=MAATG/CN=voms.gnubila.fr',
                                          'issuer', '/C=FR/O=CNRS/CN=GRID2-FR',
                                         ),
    'voms.grid.am',                 dict('subject', '/C=AM/O=ArmeSFo/O=IIAP NAS RA/OU=Center for Scientific Computing/CN=voms.grid.am',
                                          'issuer', '/C=AM/O=ArmeSFo/CN=ArmeSFo CA',
                                         ),
    'voms.grid.org.ua',             dict('subject', '/DC=org/DC=ugrid/O=hosts/O=KNU/CN=voms.grid.org.ua',
                                          'issuer', '/DC=org/DC=ugrid/CN=UGRID CA',
                                         ),
    'voms.grid.sara.nl',            dict('subject', '/O=dutchgrid/O=hosts/OU=sara.nl/CN=voms.grid.sara.nl',
                                          'issuer', '/C=NL/O=NIKHEF/CN=NIKHEF medium-security certification auth',
                                         ),
    'voms.grid.sinica.edu.tw',      dict('subject', '/C=TW/O=AS/OU=GRID/CN=voms.grid.sinica.edu.tw',
                                          'issuer', '/C=TW/O=AS/CN=Academia Sinica Grid Computing Certification Authority Mercury',
                                         ),
    'voms.grid.unam.mx',            dict('subject', '/C=MX/O=UNAMgrid/OU=DGSCA UNAM CU/CN=voms.grid.unam.mx',
                                          'issuer', '/C=MX/O=UNAMgrid/OU=UNAM/CN=CA',
                                         ),
    'voms.gridpp.ac.uk',            dict('subject', '/C=UK/O=eScience/OU=Manchester/L=HEP/CN=voms.gridpp.ac.uk',
                                          'issuer', '/C=UK/O=eScienceCA/OU=Authority/CN=UK e-Science CA 2B',
                                         ),
    'voms.hellasgrid.gr',           dict('subject', '/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms.hellasgrid.gr',
                                          'issuer', '/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016',
                                         ),
    'voms.hellasgrid.gr_2',         dict('subject', '/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms.hellasgrid.gr',
                                          'issuer', '/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2006',
                                         ),
    'voms.hep.tau.ac.il',           dict('subject', '/DC=org/DC=terena/DC=tcs/C=IL/ST=Tel Aviv/L=Tel Aviv/O=Tel Aviv University/CN=voms.hep.tau.ac.il',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms.hep.wisc.edu',            dict('subject', '/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=voms.hep.wisc.edu',
                                          'issuer', '/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1',
                                         ),
    'voms.hpcc.ttu.edu',            dict('subject', '/DC=com/DC=DigiCert-Grid/O=Open Science Grid/OU=Services/CN=http/voms.hpcc.ttu.edu',
                                          'issuer', '/DC=com/DC=DigiCert-Grid/O=DigiCert Grid/CN=DigiCert Grid CA-1',
                                         ),
    'voms.ific.uv.es',              dict('subject', '/DC=org/DC=terena/DC=tcs/C=ES/ST=Valencia/L=Burjassot/O=Universitat de Valencia/CN=voms.ific.uv.es',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms.ihep.ac.cn',              dict('subject', '/C=CN/O=HEP/OU=CC/O=IHEP/CN=voms.ihep.ac.cn',
                                          'issuer', '/C=CN/O=HEP/CN=Institute of High Energy Physics Certification Authority',
                                         ),
    'voms.ipb.ac.rs',               dict('subject', '/C=RS/O=AEGIS/OU=Institute of Physics Belgrade/CN=host/voms.ipb.ac.rs',
                                          'issuer', '/C=RS/O=AEGIS/CN=AEGIS-CA',
                                         ),
    'voms.ipp.acad.bg',             dict('subject', '/DC=bg/DC=acad/O=hosts/O=IICT-BAS/OU=GTA/CN=voms.ipp.acad.bg',
                                          'issuer', '/DC=bg/DC=acad/CN=BG.ACAD CA',
                                         ),
    'voms.magrid.ma',               dict('subject', '/C=MA/O=MaGrid/OU=CNRST/CN=voms.magrid.ma',
                                          'issuer', '/C=MA/O=MaGrid/CN=MaGrid CA',
                                         ),
    'voms.ndgf.org',                dict('subject', '/O=Grid/O=NorduGrid/CN=host/voms.ndgf.org',
                                          'issuer', '/O=Grid/O=NorduGrid/CN=NorduGrid Certification Authority 2015',
                                         ),
    'voms.sagrid.ac.za',            dict('subject', '/C=IT/O=INFN/OU=Host/L=ZA-UFS/CN=voms.sagrid.ac.za',
                                          'issuer', '/C=IT/O=INFN/CN=INFN CA',
                                         ),
    'voms.ulakbim.gov.tr',          dict('subject', '/C=TR/O=TRGrid/OU=TUBITAK-ULAKBIM/CN=voms.ulakbim.gov.tr',
                                          'issuer', '/C=TR/O=TRGrid/CN=TR-Grid CA',
                                         ),
    'voms.up.pt',                   dict('subject', '/DC=org/DC=terena/DC=tcs/C=PT/ST=Porto/L=Porto/O=Universidade do Porto/CN=voms.up.pt',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms01.ncg.ingrid.pt',         dict('subject', '/C=PT/O=LIPCA/O=LIP/OU=Lisboa/CN=voms01.ncg.ingrid.pt',
                                          'issuer', '/C=PT/O=LIPCA/CN=LIP Certification Authority',
                                         ),
    'voms01.pic.es',                dict('subject', '/DC=org/DC=terena/DC=tcs/C=ES/ST=Barcelona/L=Bellaterra/O=Port dInformacio Cientifica/CN=voms01.pic.es',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms02.gridpp.ac.uk',          dict('subject', '/C=UK/O=eScience/OU=Oxford/L=OeSC/CN=voms02.gridpp.ac.uk',
                                          'issuer', '/C=UK/O=eScienceCA/OU=Authority/CN=UK e-Science CA 2B',
                                         ),
    'voms02.pic.es',                dict('subject', '/DC=org/DC=terena/DC=tcs/C=ES/ST=Barcelona/L=Bellaterra/O=Port dInformacio Cientifica/CN=voms02.pic.es',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms02.scope.unina.it',        dict('subject', '/C=IT/O=INFN/OU=Host/L=Federico II/CN=voms02.scope.unina.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN Certification Authority',
                                         ),
    'voms03.gridpp.ac.uk',          dict('subject', '/C=UK/O=eScience/OU=Imperial/L=Physics/CN=voms03.gridpp.ac.uk',
                                          'issuer', '/C=UK/O=eScienceCA/OU=Authority/CN=UK e-Science CA 2B',
                                         ),
    'voms1.fnal.gov',               dict('subject', '/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=voms1.fnal.gov',
                                          'issuer', '/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1',
                                         ),
    'voms1.grid.cesnet.cz',         dict('subject', '/DC=org/DC=terena/DC=tcs/C=CZ/ST=Hlavni mesto Praha/L=Praha 6/O=CESNET/CN=voms1.grid.cesnet.cz',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms2.cern.ch',                dict('subject', '/DC=ch/DC=cern/OU=computers/CN=voms2.cern.ch',
                                          'issuer', '/DC=ch/DC=cern/CN=CERN Grid Certification Authority',
                                         ),
    'voms2.cnaf.infn.it',           dict('subject', '/C=IT/O=INFN/OU=Host/L=CNAF/CN=voms2.cnaf.infn.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN CA',
                                         ),
    'voms2.fnal.gov',               dict('subject', '/DC=org/DC=opensciencegrid/O=Open Science Grid/OU=Services/CN=voms2.fnal.gov',
                                          'issuer', '/DC=org/DC=cilogon/C=US/O=CILogon/CN=CILogon OSG CA 1',
                                         ),
    'voms2.grid.cesnet.cz',         dict('subject', '/DC=org/DC=terena/DC=tcs/C=CZ/ST=Hlavni mesto Praha/L=Praha 6/O=CESNET/CN=voms2.grid.cesnet.cz',
                                          'issuer', '/C=NL/ST=Noord-Holland/L=Amsterdam/O=TERENA/CN=TERENA eScience SSL CA 3',
                                         ),
    'voms2.hellasgrid.gr',          dict('subject', '/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms2.hellasgrid.gr',
                                          'issuer', '/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2016',
                                         ),
    'voms2.hellasgrid.gr_2',        dict('subject', '/C=GR/O=HellasGrid/OU=hellasgrid.gr/CN=voms2.hellasgrid.gr',
                                          'issuer', '/C=GR/O=HellasGrid/OU=Certification Authorities/CN=HellasGrid CA 2006',
                                         ),
    'vomsIGI-NA.unina.it',          dict('subject', '/C=IT/O=INFN/OU=Host/L=Federico II/CN=vomsIGI-NA.unina.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN CA',
                                         ),
    'vomsmania.cnaf.infn.it',       dict('subject', '/C=IT/O=INFN/OU=Host/L=CNAF/CN=vomsmania.cnaf.infn.it',
                                          'issuer', '/C=IT/O=INFN/CN=INFN Certification Authority',
                                         ),
);
