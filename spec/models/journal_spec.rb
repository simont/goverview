require 'spec_helper'

describe Journal do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Journal.create!(@valid_attributes)
  end
end

describe "parse jlist and update from PMC list" do
  it "should split into a hash" do
    pmc_row = '"Advances in Urology","Adv Urol","1687-6369","1687-6377","Hindawi Publishing Corporation","101476240","v.2009;2009","v.2008;2008","Immediate","All"," Full "," ",http://www.pubmedcentral.nih.gov/tocrender.fcgi?action=archive&journal=632'
    j_params = Journal.parse_jlist_row(pmc_row)
    j_params.keys.size.should == 8
    j_params['abbrev_title'].should == 'Adv Urol'
    j_params['home_page_url'].should == 'http://www.pubmedcentral.nih.gov/tocrender.fcgi?action=archive&journal=632'
    j_params['open_access'].should == 'All'
    j_params['participation_level'].should == 'Full' 
  end

  it "should be able to update journal data from PMC journal list" do
    
    j = Journal.create({'abbrev_title' => 'Adv Urol'})
    j.save
    j.abbrev_title.should == "Adv Urol"
    pmc_row = '"Advances in Urology","Adv Urol","1687-6369","1687-6377","Hindawi Publishing Corporation","101476240","v.2009;2009","v.2008;2008","Immediate","All"," Full "," ",http://www.pubmedcentral.nih.gov/tocrender.fcgi?action=archive&journal=632'
    
    lambda { Journal.update_from_pmc_journal_list(pmc_row) }.should_not raise_error
    new_j = Journal.update_from_pmc_journal_list(pmc_row)
    new_j.title.should == "Advances in Urology"
    new_j.open_access.should == "All"
    new_j.home_page_url.should == "http://www.pubmedcentral.nih.gov/tocrender.fcgi?action=archive&journal=632"
    
  end
end
