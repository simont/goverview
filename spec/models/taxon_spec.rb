require 'spec_helper'

describe Taxon do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Taxon.create!(@valid_attributes)
  end
end
