class Annotation < ActiveRecord::Base
  belongs_to :publication
  
  
  def self.create_from_gaf(entry)
    params = {
      'db' => entry.db,
      'aspect' => entry.aspect,
      'db_object_id' => entry.db_object_id,
      'db_object_symbol'  =>  entry.db_object_symbol,
      'db_reference' => entry.db_reference.join('|'),
      'assigned_by'  => entry.assigned_by,
    }
    
    annot = Annotation.create!(params)
    pub = Annotation.create_pub_from_gaf_db_reference(entry.db_reference)
    if pub != nil
      annot.publication = pub
    end
    
    return annot
  end
  
  def self.create_pub_from_gaf_db_reference(db_reference)
    pmids = /PMID\:(\d+)/.match(db_reference.to_s)
    if pmids
      return Publication.find_or_create_by_pmid({'pmid' => $1})
    else
      return nil 
    end
  end
  
end
