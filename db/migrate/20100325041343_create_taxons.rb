class CreateTaxons < ActiveRecord::Migration
  def self.up
    create_table :taxons do |t|
      t.integer :ncbi_taxon_id
      t.string :genus, :species, :common_name
      t.timestamps
    end
    
     # add the journal FK column to publications
      rename_column :annotations, :taxon, :taxon_entry
      add_column :annotations, :taxon_id, :integer
      
      Annotation.find(:all).each do |annot|
        annot.taxon = Annotation.create_taxon_from_gaf_taxon(annot.taxon_entry)
        annot.save
      end
  end

  def self.down
    drop_table :taxons
    remove_column :annotations, :taxon_id
    rename_column :annotations, :taxon_entry, :taxon
  end
end
