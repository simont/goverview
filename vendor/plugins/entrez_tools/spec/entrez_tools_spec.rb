require File.join(File.dirname(__FILE__), *%w[spec_helper])
require 'rubygems'
require 'bio'

describe "it should parse references" do
  
  it "should be able to find a specific PMID" do
    pmid = 19358578
    pmText = Bio::PubMed.query(pmid)
    pmText.should == "PMID- 19358578\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20090608\nDCOM- 20090914\nIS  - 1535-3893 (Print)\nIS  - 1535-3893 (Linking)\nVI  - 8\nIP  - 6\nDP  - 2009 Jun\nTI  - Low cost, scalable proteomics data analysis using Amazon's cloud computing\n      services and open source search algorithms.\nPG  - 3148-53\nAB  - One of the major difficulties for many laboratories setting up proteomics\n      programs has been obtaining and maintaining the computational infrastructure\n      required for the analysis of the large flow of proteomics data. We describe a\n      system that combines distributed cloud computing and open source software to\n      allow laboratories to set up scalable virtual proteomics analysis clusters\n      without the investment in computational hardware or software licensing fees.\n      Additionally, the pricing structure of distributed computing providers, such as\n      Amazon Web Services, allows laboratories or even individuals to have large-scale \n      computational resources at their disposal at a very low cost per run. We provide \n      detailed step-by-step instructions on how to implement the virtual proteomics\n      analysis clusters as well as a list of current available preconfigured Amazon\n      machine images containing the OMSSA and X!Tandem search algorithms and sequence\n      databases on the Medical College of Wisconsin Proteomics Center Web site (\n      http://proteomics.mcw.edu/vipdac ).\nAD  - Biotechnology and Bioengineering Center, Medical College of Wisconsin, 8701\n      Watertown Plank Road, Milwaukee, Wisconsin 53226, USA. Halligan@mcw.edu\nFAU - Halligan, Brian D\nAU  - Halligan BD\nFAU - Geiger, Joey F\nAU  - Geiger JF\nFAU - Vallejos, Andrew K\nAU  - Vallejos AK\nFAU - Greene, Andrew S\nAU  - Greene AS\nFAU - Twigger, Simon N\nAU  - Twigger SN\nLA  - eng\nGR  - N01 HV-28182/HV/NHLBI NIH HHS/United States\nPT  - Journal Article\nPT  - Research Support, N.I.H., Extramural\nPL  - United States\nTA  - J Proteome Res\nJT  - Journal of proteome research\nJID - 101128775\nSB  - IM\nMH  - *Algorithms\nMH  - Cluster Analysis\nMH  - Databases, Protein\nMH  - Internet\nMH  - Proteomics/*methods\nMH  - *Software\nPMC - PMC2691775\nMID - NIHMS115457\nOID - NLM: NIHMS115457 [Available on 06/05/10]\nOID - NLM: PMC2691775 [Available on 06/05/10]\nEDAT- 2009/04/11 09:00\nMHDA- 2009/09/15 06:00\nCRDT- 2009/04/11 09:00\nPMCR- 2010/06/05\nAID - 10.1021/pr800970z [doi]\nPST - ppublish\nSO  - J Proteome Res. 2009 Jun;8(6):3148-53.\n"
    
    medline = Bio::MEDLINE.new(pmText)
    
  end
  
  # it "should be able to split a set of concatenated PMID records" do
  #   
  #   test_string = "PMID- 19358578\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20090608\nDCOM- 20090914\nPMID- 19358578\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20090608\nDCOM- 20090914\n"
  #   ref_tool = EntrezTools.new("spec_test")
  #   pm_records = ref_tool.split_bulk_pmText(test_string)
  #   pm_records[1].should == "PMID- 19358578\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20090608\nDCOM- 20090914\n"
  #   pm_records.size.should == 2
  #   
  # end
  
  it "should be able to cache some pmText" do
    ref_tool = EntrezTools.new("spec_test")
    pmText = ref_tool.get_pmText('19358578')
    # ref_tool.cache_pmText(pmText).should == "19358578"
    ref_tool.cached?(19358578).should == pmText
    # Calling delete when its in the cache should return true
    ref_tool.cache_delete(19358578).should == true
    
    # second delete should return false
    ref_tool.cache_delete(19358578) == false
    
    #shouldnt be there any more and will raise errro
    lambda {  ref_tool.cached?(19358578) }.should raise_error(Memcached::NotFound)
  end
  
  it "should be able to use efetch" do
    pmid_list_short = "19902431,19902421,19902407,19902356"
    ref_tool = EntrezTools.new("spec_test")
    
    refs = ref_tool.get_pmText_for_pmid_list(pmid_list_short)
    refs.size.should == 4
    
    refs2 = ref_tool.get_pmText_for_pmid_list([19902431,19902421,19902407,19902356])
    refs2.size.should == 4
    
     # Calling delete when its in the cache should return true
    ref_tool.cache_delete(19902407).should == true
    
  end
  
  
  it "should be able to get pubmed data in batch mode" do
    
    pmid_list_long = "19902431,19902421,19902407,19902356,19902350,19902229,19902219,19902206,19902172,19901993,19901991,19901953,19901945,19901907,19901670,19901553,19901552,19901420,19901392,19901344,19901307,19901268,19901213,19901198,19901190,19901138,19901120,19901090,19901072"
    pmid_list_short = "19902431,19902421,19902407,19902356"
    
    ref_tool = EntrezTools.new("spec_test")
    
    pmText = ref_tool.get_bulk_pmText(pmid_list_short,2)
    pmText.size.should == 4
    pmText[0].should == "PMID- 19902431\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20100104\nDCOM- 20100310\nIS  - 1613-6829 (Electronic)\nIS  - 1613-6810 (Linking)\nVI  - 6\nIP  - 1\nDP  - 2010 Jan\nTI  - Enrichment of (8,4) single-walled carbon nanotubes through coextraction\n      with heparin.\nPG  - 110-8\nAB  - Heparin sodium salt is investigated as a dispersant for dispersing\n      single-walled carbon nanotubes (SWNTs). Photoluminescence excitation (PLE)\n      spectroscopy is used for identification and abundance estimation of the\n      chiral species. It is found that heparin sodium salt preferentially\n      disperses larger-diameter Hipco SWNTs. When used to disperse CoMoCAT\n      nanotube samples, heparin has a strong preference for (8,4) tubes, which\n      have larger diameter than the predominant (6,5) in pristine CoMoCAT\n      samples. PLE intensity due to (8,4) tubes increases from 7% to 60% of the\n      total after threefold extractions. Computer modeling verifies that the\n      complex of (8,4) SWNTs and heparin has the lowest binding energy amongst\n      the four semiconducting species present in CoMoCAT. Network field-effect\n      transistors are successfully made with CoMoCAT/heparin and CoMoCAT/sodium\n      dodecylbenzene sulfonate (SDBS)-heparin (x3), confirming the easy\n      removability of heparin.\nAD  - School of Chemical & Biomedical Engineering, Nanyang Technological\n      University, 62 Nanyang Drive, Singapore 637459, Singapore.\nFAU - Yan, Liang Yu\nAU  - Yan LY\nFAU - Li, Weifeng\nAU  - Li W\nFAU - Fan, Xiao Feng\nAU  - Fan XF\nFAU - Wei, Li\nAU  - Wei L\nFAU - Chen, Yuan\nAU  - Chen Y\nFAU - Kuo, Jer-Lai\nAU  - Kuo JL\nFAU - Li, Lain-Jong\nAU  - Li LJ\nFAU - Kwak, Sang Kyu\nAU  - Kwak SK\nFAU - Mu, Yuguang\nAU  - Mu Y\nFAU - Chan-Park, M B\nAU  - Chan-Park MB\nLA  - eng\nPT  - Journal Article\nPT  - Research Support, Non-U.S. Gov't\nPL  - Germany\nTA  - Small\nJT  - Small (Weinheim an der Bergstrasse, Germany)\nJID - 101235338\nRN  - 0 (Macromolecular Substances)\nRN  - 0 (Nanotubes, Carbon)\nRN  - 9005-49-6 (Heparin)\nSB  - IM\nMH  - Crystallization/*methods\nMH  - Heparin/*chemistry\nMH  - Macromolecular Substances/chemistry\nMH  - Materials Testing\nMH  - Molecular Conformation\nMH  - Nanotechnology/*methods\nMH  - Nanotubes, Carbon/*chemistry/*ultrastructure\nMH  - Particle Size\nMH  - Solid Phase Extraction/methods\nMH  - Surface Properties\nEDAT- 2009/11/11 06:00\nMHDA- 2010/03/11 06:00\nCRDT- 2009/11/11 06:00\nAID - 10.1002/smll.200900865 [doi]\nPST - ppublish\nSO  - Small. 2010 Jan;6(1):110-8."
    
  end
  
end