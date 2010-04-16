require 'spec_helper'

describe Publication do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Publication.create!(@valid_attributes)
  end
  
end

describe "it should fetch data from PubMed" do
  
  before :each do 
    @pmText = Publication.get_pmid_data_from_pubmed(19358578)
  end
  
  it "should take a pubmed ID and retrieve data from PubMed" do
    @pmText.should == "PMID- 19358578\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20090608\nDCOM- 20090914\nIS  - 1535-3893 (Print)\nIS  - 1535-3893 (Linking)\nVI  - 8\nIP  - 6\nDP  - 2009 Jun\nTI  - Low cost, scalable proteomics data analysis using Amazon's cloud computing\n      services and open source search algorithms.\nPG  - 3148-53\nAB  - One of the major difficulties for many laboratories setting up proteomics\n      programs has been obtaining and maintaining the computational\n      infrastructure required for the analysis of the large flow of proteomics\n      data. We describe a system that combines distributed cloud computing and\n      open source software to allow laboratories to set up scalable virtual\n      proteomics analysis clusters without the investment in computational\n      hardware or software licensing fees. Additionally, the pricing structure\n      of distributed computing providers, such as Amazon Web Services, allows\n      laboratories or even individuals to have large-scale computational\n      resources at their disposal at a very low cost per run. We provide\n      detailed step-by-step instructions on how to implement the virtual\n      proteomics analysis clusters as well as a list of current available\n      preconfigured Amazon machine images containing the OMSSA and X!Tandem\n      search algorithms and sequence databases on the Medical College of\n      Wisconsin Proteomics Center Web site ( http://proteomics.mcw.edu/vipdac ).\nAD  - Biotechnology and Bioengineering Center, Medical College of Wisconsin,\n      8701 Watertown Plank Road, Milwaukee, Wisconsin 53226, USA.\n      Halligan@mcw.edu\nFAU - Halligan, Brian D\nAU  - Halligan BD\nFAU - Geiger, Joey F\nAU  - Geiger JF\nFAU - Vallejos, Andrew K\nAU  - Vallejos AK\nFAU - Greene, Andrew S\nAU  - Greene AS\nFAU - Twigger, Simon N\nAU  - Twigger SN\nLA  - eng\nGR  - N01 HV-28182/HV/NHLBI NIH HHS/United States\nPT  - Journal Article\nPT  - Research Support, N.I.H., Extramural\nPL  - United States\nTA  - J Proteome Res\nJT  - Journal of proteome research\nJID - 101128775\nSB  - IM\nMH  - *Algorithms\nMH  - Cluster Analysis\nMH  - Databases, Protein\nMH  - Internet\nMH  - Proteomics/*methods\nMH  - *Software\nPMC - PMC2691775\nMID - NIHMS115457\nOID - NLM: NIHMS115457 [Available on 06/05/10]\nOID - NLM: PMC2691775 [Available on 06/05/10]\nEDAT- 2009/04/11 09:00\nMHDA- 2009/09/15 06:00\nCRDT- 2009/04/11 09:00\nPMCR- 2010/06/05\nAID - 10.1021/pr800970z [doi]\nPST - ppublish\nSO  - J Proteome Res. 2009 Jun;8(6):3148-53."
    
    
  end
  
  it "should be able to convert text to MEDLINE object" do
    medline = Bio::MEDLINE.new(@pmText)
    medline.pmid.should == "19358578"
    medline.year.should == "2009"
    medline.authors.size.should == 5
    medline.authors[0].should == "Halligan, B. D."
  end
  
  it "should be able to load MEDLINE data into the database" do
    medline = Bio::MEDLINE.new(@pmText)
    pub = Publication.create_from_MEDLINE(medline)
    pub.pmid.should == 19358578
    pub.year.year.should == 2009
    pub.authors.size.should == 5
    pub.authors.first.name_plus_initials.should == "Halligan, B. D."
  end
  
  it "should be able to use the EntrezTools and cache requests" do
    ref_tool = EntrezTools.new("spec_test")
    new_pmText = ref_tool.get_pmText('19902431')
    ref_tool.cached?(19902431).should == new_pmText
    # Calling delete when its in the cache should return true
    ref_tool.cache_delete(19902431).should == true
    
    # second delete should return false
    ref_tool.cache_delete(19902431) == false
    
    #shouldnt be there any more and will raise errro
    lambda {  ref_tool.cached?(19902431) }.should raise_error(Memcached::NotFound)
    
    #create new medline object from the text
    medline = Bio::MEDLINE.new(new_pmText)
    pub = Publication.create_from_MEDLINE(medline)
    pub.pmid.should == 19902431
  end
  
  it "should be able to creat pubs en mass" do
    pubmed_ids = "19358578,19902431"
    ref_tool = EntrezTools.new("spec_test")
    pubTexts = ref_tool.get_bulk_pmText(pubmed_ids,2)
    pubTexts.should == ["PMID- 19358578\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20090608\nDCOM- 20090914\nIS  - 1535-3893 (Print)\nIS  - 1535-3893 (Linking)\nVI  - 8\nIP  - 6\nDP  - 2009 Jun\nTI  - Low cost, scalable proteomics data analysis using Amazon's cloud computing\n      services and open source search algorithms.\nPG  - 3148-53\nAB  - One of the major difficulties for many laboratories setting up proteomics\n      programs has been obtaining and maintaining the computational\n      infrastructure required for the analysis of the large flow of proteomics\n      data. We describe a system that combines distributed cloud computing and\n      open source software to allow laboratories to set up scalable virtual\n      proteomics analysis clusters without the investment in computational\n      hardware or software licensing fees. Additionally, the pricing structure\n      of distributed computing providers, such as Amazon Web Services, allows\n      laboratories or even individuals to have large-scale computational\n      resources at their disposal at a very low cost per run. We provide\n      detailed step-by-step instructions on how to implement the virtual\n      proteomics analysis clusters as well as a list of current available\n      preconfigured Amazon machine images containing the OMSSA and X!Tandem\n      search algorithms and sequence databases on the Medical College of\n      Wisconsin Proteomics Center Web site ( http://proteomics.mcw.edu/vipdac ).\nAD  - Biotechnology and Bioengineering Center, Medical College of Wisconsin,\n      8701 Watertown Plank Road, Milwaukee, Wisconsin 53226, USA.\n      Halligan@mcw.edu\nFAU - Halligan, Brian D\nAU  - Halligan BD\nFAU - Geiger, Joey F\nAU  - Geiger JF\nFAU - Vallejos, Andrew K\nAU  - Vallejos AK\nFAU - Greene, Andrew S\nAU  - Greene AS\nFAU - Twigger, Simon N\nAU  - Twigger SN\nLA  - eng\nGR  - N01 HV-28182/HV/NHLBI NIH HHS/United States\nPT  - Journal Article\nPT  - Research Support, N.I.H., Extramural\nPL  - United States\nTA  - J Proteome Res\nJT  - Journal of proteome research\nJID - 101128775\nSB  - IM\nMH  - *Algorithms\nMH  - Cluster Analysis\nMH  - Databases, Protein\nMH  - Internet\nMH  - Proteomics/*methods\nMH  - *Software\nPMC - PMC2691775\nMID - NIHMS115457\nOID - NLM: NIHMS115457 [Available on 06/05/10]\nOID - NLM: PMC2691775 [Available on 06/05/10]\nEDAT- 2009/04/11 09:00\nMHDA- 2009/09/15 06:00\nCRDT- 2009/04/11 09:00\nPMCR- 2010/06/05\nAID - 10.1021/pr800970z [doi]\nPST - ppublish\nSO  - J Proteome Res. 2009 Jun;8(6):3148-53.", "PMID- 19902431\nOWN - NLM\nSTAT- MEDLINE\nDA  - 20100104\nDCOM- 20100310\nIS  - 1613-6829 (Electronic)\nIS  - 1613-6810 (Linking)\nVI  - 6\nIP  - 1\nDP  - 2010 Jan\nTI  - Enrichment of (8,4) single-walled carbon nanotubes through coextraction\n      with heparin.\nPG  - 110-8\nAB  - Heparin sodium salt is investigated as a dispersant for dispersing\n      single-walled carbon nanotubes (SWNTs). Photoluminescence excitation (PLE)\n      spectroscopy is used for identification and abundance estimation of the\n      chiral species. It is found that heparin sodium salt preferentially\n      disperses larger-diameter Hipco SWNTs. When used to disperse CoMoCAT\n      nanotube samples, heparin has a strong preference for (8,4) tubes, which\n      have larger diameter than the predominant (6,5) in pristine CoMoCAT\n      samples. PLE intensity due to (8,4) tubes increases from 7% to 60% of the\n      total after threefold extractions. Computer modeling verifies that the\n      complex of (8,4) SWNTs and heparin has the lowest binding energy amongst\n      the four semiconducting species present in CoMoCAT. Network field-effect\n      transistors are successfully made with CoMoCAT/heparin and CoMoCAT/sodium\n      dodecylbenzene sulfonate (SDBS)-heparin (x3), confirming the easy\n      removability of heparin.\nAD  - School of Chemical & Biomedical Engineering, Nanyang Technological\n      University, 62 Nanyang Drive, Singapore 637459, Singapore.\nFAU - Yan, Liang Yu\nAU  - Yan LY\nFAU - Li, Weifeng\nAU  - Li W\nFAU - Fan, Xiao Feng\nAU  - Fan XF\nFAU - Wei, Li\nAU  - Wei L\nFAU - Chen, Yuan\nAU  - Chen Y\nFAU - Kuo, Jer-Lai\nAU  - Kuo JL\nFAU - Li, Lain-Jong\nAU  - Li LJ\nFAU - Kwak, Sang Kyu\nAU  - Kwak SK\nFAU - Mu, Yuguang\nAU  - Mu Y\nFAU - Chan-Park, M B\nAU  - Chan-Park MB\nLA  - eng\nPT  - Journal Article\nPT  - Research Support, Non-U.S. Gov't\nPL  - Germany\nTA  - Small\nJT  - Small (Weinheim an der Bergstrasse, Germany)\nJID - 101235338\nRN  - 0 (Macromolecular Substances)\nRN  - 0 (Nanotubes, Carbon)\nRN  - 9005-49-6 (Heparin)\nSB  - IM\nMH  - Crystallization/*methods\nMH  - Heparin/*chemistry\nMH  - Macromolecular Substances/chemistry\nMH  - Materials Testing\nMH  - Molecular Conformation\nMH  - Nanotechnology/*methods\nMH  - Nanotubes, Carbon/*chemistry/*ultrastructure\nMH  - Particle Size\nMH  - Solid Phase Extraction/methods\nMH  - Surface Properties\nEDAT- 2009/11/11 06:00\nMHDA- 2010/03/11 06:00\nCRDT- 2009/11/11 06:00\nAID - 10.1002/smll.200900865 [doi]\nPST - ppublish\nSO  - Small. 2010 Jan;6(1):110-8."]
    
    pubs = []
    pubTexts.each do |pmText|
      medline = Bio::MEDLINE.new(pmText)
      pubs << Publication.create_from_MEDLINE(medline)
    end
    pubs.size.should == 2
    
  end
  
  it "should be able to get and load batches of pubmed data" do
    Publication.delete_all
    Publication.find(:all).size.should == 0
    pubmed_ids = "19358578,19902431"
    pubs = Publication.create_batch_pub_records(pubmed_ids)
    pubs.size.should == 2
    Publication.find(:all).size.should == 2
    Author.find(:all).size.should == 15
    Author.find(:first).name_plus_initials.should == 'Halligan, B. D.'
    Author.find(:last).name_plus_initials.should == 'Chan-Park, M. B.'
  end
  
  it "should not create duplicate entries" do
    Publication.delete_all
    Publication.find(:all).size.should == 0
    pubmed_ids = "19358578,19358578"
    pubs = Publication.create_batch_pub_records(pubmed_ids)
    Publication.find(:all).size.should == 1
  end
end

describe "fill in stub entries only" do
  it "should know if its only a stub, a partially filled out pub record" do
    pending
    
    pubmed_ids = "19358578,19902431"
    pubs = Publication.create_batch_pub_records(pubmed_ids)
    pubs.size.should == 2
    pubs[0].is_stub?.should == false
    pubs[0].authors = nil
    pubs[0].is_stub?.should == true
  end
  
  it "should be able to update stubbed entries" do
    pending
    
    pubmed_ids = "19358578,19902431"
    pubs = Publication.create_batch_pub_records(pubmed_ids)
    # pubs[0].title = nil
    pubs[0].save!
    pubs[0].authors.empty?.should == false
    pubs[0].authors.first.name_plus_initials.should == "Halligan, B. D."
    pubs[0].year.year.should == 2009
    pubs[0].is_stub?.should == false
    
    #run the update method to fill in the stub entries
    Publication.update_stubs_from_pubmed.should == 1
    updated_pub = Publication.find_by_pmid(19358578)
    updated_pub.year.year.should == 2009
    updated_pub.is_stub?.should == false
    updated_pub.title.should == "Low cost, scalable proteomics data analysis using Amazon's cloud computing services and open source search algorithms."
    
  end
end

describe "create date range data for pub graph" do
  
  it "should get pub date info from the database" do
    pubmed_ids = "19358578,19902431"
    pubs = Publication.create_batch_pub_records(pubmed_ids)
    sql = "select YEAR(year), count(*) as total from publications group by YEAR(year)"
    dates = Publication.count(:all, :group => "YEAR(year)")
    dates.should == {"2009" => 1, "2010" => 1}
  end
end