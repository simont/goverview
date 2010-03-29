require 'rubygems'
require 'bio'

namespace :pubs do

  desc "updates all stubbed Publication records from PubMed"
  task(:update_stubs => :environment) do
    puts "Updating stub pubs"
    updated_pubs = Publication.update_stubs_from_pubmed
    puts "Update info for #{updated_pubs} publication records"
  end
end
