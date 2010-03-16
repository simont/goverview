class CreatePublications < ActiveRecord::Migration
  def self.up
    create_table :publications do |t|
      t.integer :pmid
      t.text :title
      t.timestamps
    end
  end

  def self.down
    drop_table :publications
  end
end
