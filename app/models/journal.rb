class Journal < ActiveRecord::Base
  has_many :publications
  
  # updates the Journal data from the PMC open access journals list
  # See: http://www.ncbi.nlm.nih.gov/pmc/journals/#csvfile
  
  def self.update_from_pmc_journal_list(jlist_row)
    

    j_params = parse_jlist_row(jlist_row)
    puts "Checking #{j_params['abbrev_title']}"
    
    # Find the matching journal record
    journal = Journal.find_by_abbrev_title(j_params['abbrev_title'])
    # and update with the new data.
    
    if journal != nil
      journal.update_attributes(j_params)
    end
    
    return journal
    
  end
  
  
  private 
  
  def self.parse_jlist_row(jlist_row)
    
    data = jlist_row.split(',')
    j_params = {
      'title' => data[0].gsub(/^\"(.+)\"$/, '\1').strip,
      'abbrev_title' => data[1].gsub(/^\"(.+)\"$/, '\1').strip,
      'pissn' => data[2].gsub(/^\"(.+)\"$/, '\1'),
      'eissn' => data[3].gsub(/^\"(.+)\"$/, '\1'),
      'free_access' => data[8].gsub(/^\"(.+)\"$/, '\1'),
      'open_access' => data[9].gsub(/^\"(.+)\"$/, '\1'),
      'participation_level' => data[10].gsub(/^\"(.+)\"$/, '\1').strip,
      'home_page_url' => data[12]
    }
    
  end
  
end
