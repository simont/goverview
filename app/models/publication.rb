require 'bio'

class Publication < ActiveRecord::Base
  has_many :annotations
  belongs_to :journal
  has_and_belongs_to_many :authors, :join_table => "authors_publications"
  validates_uniqueness_of :pmid
  
  def self.get_pmid_data_from_pubmed(pmid)   
    #TODO Hard coding the cache identifier here isnt the best plan.
    ref_tool = EntrezTools.new("goverview")
    return ref_tool.get_pmText(pmid)
  end
  
  def self.medline_to_hash(medline)
    hash = {
      'pmid' => medline.pmid,
      'year' =>  Date.new(medline.year.to_i),
      'title' => medline.title,
      'volume' => medline.volume,
      'issue' => medline.issue,
      'pages' => medline.pages,
      'publication_type' => medline.publication_type
    }
    
  end
  
  def self.create_from_MEDLINE(medline)
    pub = Publication.find_by_pmid(medline.pmid)
    
    if pub == nil
      pub = Publication.create(Publication.medline_to_hash(medline))
    
      # TODO create link to Journal
      journal = Journal.find_or_create_by_abbrev_title(medline.journal)
      if journal
        pub.journal = journal
      end
    
      medline.authors.each do |author|
        author_record = Author.find_or_create_by_name_plus_initials({'name_plus_initials' => author})
        author_record.save!
        pub.authors << author_record
      end
      pub.save!
    end
    
    return pub
  end
  
  def self.create_batch_pub_records(pmids)
    ref_tool = EntrezTools.new("goverview")
    pubTexts = ref_tool.get_bulk_pmText(pmids,50)
    pubs = []
    pubTexts.each do |pmText|
      medline = Bio::MEDLINE.new(pmText)
      pubs << Publication.create_from_MEDLINE(medline)
    end
    return pubs
  end
  
  # is this a stub entry with no data - yes if there is no title entry
  
  def is_stub?
    self.authors.empty? ? true : false
  end
  
  def self.update_stubs_from_pubmed
    pubs_to_update = []
    
    Publication.find(:all, :conditions => "year is null or year = '0000-00-00'").each do |pub|
      if pub.pmid != nil
        pubs_to_update << pub
      end
    end
    
    pmid_list = []
    pubs_to_update.each do |pub|
      pmid_list << pub.pmid
    end
    
    ref_tool = EntrezTools.new("goverview")
    puts "There are #{pmid_list.size} pubs to update"
    
    start_index = 0
    increment = 500
    while start_index < pmid_list.size
      
      puts "Getting data for #{start_index} -> #{start_index+increment}"
      pmTextList = ref_tool.get_bulk_pmText(pmid_list[start_index..(start_index+increment)].join(','),increment)
      
      puts "Got data for #{pmTextList.size} pubs"
      pmTextList.each do |pmText|
        medline = Bio::MEDLINE.new(pmText)
        begin
          pub = Publication.find_by_pmid(medline.pmid)
          pub.update_attributes(Publication.medline_to_hash(medline))
        
          journal = Journal.find_or_create_by_abbrev_title(medline.journal)
          if journal
            pub.journal = journal
          end
          
          if pub.authors.empty?
            # Add in the author records too
            medline.authors.each do |author|
              author_record = Author.find_or_create_by_name_plus_initials({'name_plus_initials' => author})
              author_record.save!
              pub.authors << author_record
            end
          end
          
          pub.save!
        rescue
          "Problem finding and updating pubication record for #{pmText}"
        end
      end
      start_index = start_index + increment -1
    end
    
    return pubs_to_update.size
  end
  
end
