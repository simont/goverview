class AddFieldsToPublication < ActiveRecord::Migration
  def self.up
    add_column :publications, :year, :date
    add_column :publications, :journal, :string
    add_column :publications, :volume, :string
    add_column :publications, :issue, :string
    add_column :publications, :pages, :string
    add_column :publications, :affiliation, :text
    add_column :publications, :publication_type, :string
  end

  def self.down
    remove_column :publications, :year
    remove_column :publications, :journal
    remove_column :publications, :volume
    remove_column :publications, :issue
    remove_column :publications, :pages
    remove_column :publications, :affiliation
    remove_column :publications, :publication_type
  end
end
