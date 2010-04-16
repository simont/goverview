require 'spec_helper'

describe "taxons/show.html.erb" do
  
  before (:each) do
    
  end
  
  it "displays info about the publication" do
    taxon = mock_model(Taxon, :genus => "Rattus", :species => "norvegicus", :annotations => 123)
    assigns[:taxon] = taxon
    
    
    render
    
  end
end