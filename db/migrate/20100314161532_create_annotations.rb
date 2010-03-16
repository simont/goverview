class CreateAnnotations < ActiveRecord::Migration
  def self.up
    create_table :annotations do |t|
      t.string :db,:db_object_id, :db_object_symbol, :qualifier, :go_id, :db_reference, :evidence, :with, :aspect, :db_object_name, :db_object_synonym, :taxon
      t.datetime :date
      t.string :assigned_by, :annotation_extension, :gene_product_form_id
      t.integer :publication_id
      t.timestamps
    end
  end

  def self.down
    drop_table :annotations
  end
end
