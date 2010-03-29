class Annotation < ActiveRecord::Base
  belongs_to :publication
  belongs_to :taxon
  
  
  def self.create_from_gaf(entry)
    params = {
      'db' => entry.db,
      'go_id' => entry.goid,
      'aspect' => entry.aspect,
      'db_object_id' => entry.db_object_id,
      'db_object_symbol'  =>  entry.db_object_symbol,
      'db_object_name' => entry.db_object_name,
      'db_reference' => entry.db_reference.join('|'),
      'evidence' => entry.evidence,
      'taxon_entry' => entry.taxon,
      'date' => entry.date,
      'with' => entry.with,
      'qualifier' => entry.qualifier,
      'assigned_by'  => entry.assigned_by,
    }
    
    annot = Annotation.create!(params)
    
    taxon_record = Annotation.create_taxon_from_gaf_taxon(entry.taxon)
    if taxon_record != nil
      annot.taxon = taxon_record
    end
    
    pub = Annotation.create_pub_from_gaf_db_reference(entry.db_reference)
    if pub != nil
      annot.publication = pub
    end
    annot.save
    return annot
  end
  
  def self.create_pub_from_gaf_db_reference(db_reference)
    
    # TODO use string::scan here to get multiple PMID recors
    # will need a model change to habtm
    pmids = /PMID\:(\d+)/.match(db_reference.to_s)
    if pmids
      return Publication.find_or_create_by_pmid({'pmid' => $1})
    else
      return nil 
    end
  end
  
  def self.create_taxon_from_gaf_taxon(taxon_info)
    taxon = taxon_info.scan(/taxon:(\d+)/)
    if !taxon.empty?
      return Taxon.find_or_create_by_ncbi_taxon_id({'ncbi_taxon_id'=>taxon.flatten.first})
    else
      return nil
    end
  end
  
end
