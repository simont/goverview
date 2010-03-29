class CreateJournals < ActiveRecord::Migration
  def self.up
    create_table :journals do |t|
      t.string :title, :abbrev_title
      t.string :home_page_url
      t.boolean :is_open_access, :default => false
      t.timestamps
    end

    # add the journal FK column to publications
    add_column :publications, :journal_id, :integer
    
    #for each publication, create appropriate Journal records and connect up
    Publication.find(:all).each do |pub|
      # puts "Checking #{pub.journal_title}"
      journal = Journal.find_or_create_by_abbrev_title({'abbrev_title' => pub.journal_title})
      pub.journal = journal
      pub.save
    end
    
  end

  def self.down
    remove_column :publications, :journal_id
    drop_table :journals
  end
end
