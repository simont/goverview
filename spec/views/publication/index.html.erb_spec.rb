require 'spec_helper'

describe "publications/index.html.erb" do
  
  before (:each) do
    
  end
  
  it "displays info about all publications" do
    pub1 = mock_model(Publication, :title => "the title", :url => "http://test.com", :journal => "Nature", :annotations => [1,2,3], :total => 5)
    assigns[:publication_count] = 2
    assigns[:top_pubs] = [pub1]
    
    
    
    response.should contain("BY THE NUMBERS")
    response.should contain("TOTAL PUBLICATIONS IN THE DATABASE")
    response.should contain("2")
    
    response.should contain("TOP 20")
    response.should contain("TOP 20 PUBLICATIONS BY TOTAL ANNOTATIONS")
    response.should contain("the title: 5")
    

    
  end
end