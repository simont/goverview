class AuthorsPublications < ActiveRecord::Migration
  def self.up
    create_table :authors_publications, :id => false do |t|
      t.integer :author_id, :publication_id
    end
  end

  def self.down
    drop_table :authors_publications
  end
end
