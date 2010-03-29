class ExpandJournalTable < ActiveRecord::Migration
  def self.up
    add_column :journals, :pissn, :string
    add_column :journals, :eissn, :string
    add_column :journals, :participation_level, :string, { :default => "none" }
    add_column :journals, :free_access, :string, { :default => "none" }
    rename_column :journals, :is_open_access, :open_access
    change_column :journals, :open_access, :string, { :default => "no" }
  end

  def self.down
    remove_column :journals, :pissn
    remove_column :journals, :eissn
    remove_column :journals, :participation_level
    remove_column :journals, :free_access
    change_column :journals, :open_access, :boolean
    rename_column :journals, :open_access, :is_open_access
  end
end
