require 'rubygems'
require 'bio'

namespace :go do

  desc "loads the GO annotations from a specified Gene Annotation File GAF"
  task :load_gaf, :file, :needs => :environment do |t,args|
    puts "Loading new GAF data"
    args.with_defaults(:file => 'gene_association.rgd')
    
    the_file = args[:file]
    go_data = File.open(the_file).read
    
    puts "There are #{Annotation.count(:all)} annotations prior to loading"
    Bio::GO::GeneAssociation.parser(go_data) do |entry|
       Annotation.create_from_gaf(entry)
    end
    puts "Loaded GAF data from #{the_file}, #{Annotation.count(:all)} annotations after loading"
  end
end