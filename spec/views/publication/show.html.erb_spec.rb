require 'spec_helper'

describe "publications/show.html.erb" do
  
  before (:each) do
    
  end
  
  it "displays info about the publication" do
    publication = mock_model(Publication, :title => "the title", :url => "http://test.com", :journal => "Nature", :annotations => [1,2,3])
    assigns[:publication] = publication
    
    
    render
    response.should contain("Title: the title")
    response.should contain("Journal: Nature")
    response.should contain("Annotations: 3")
    
  end
end