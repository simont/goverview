require 'spec_helper'

describe "taxons/index.html.erb" do
  
  before (:each) do
    
    @taxon = mock_model(Taxon)
    @taxon.stub!(:id).and_return(1)
    @taxon.stub!(:genus).and_return("Rattus")
    @taxon.stub!(:species).and_return("norvegicus")
    
  end
  
  it "displays the text of the supplied message" do
    assigns[:taxon_count] = 2
    assigns[:annotations_by_taxon] = [[1,123],[2,456]]
    render
    response.should contain("Hello world!")
  end
end