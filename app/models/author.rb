class Author < ActiveRecord::Base
  has_and_belongs_to_many :publications, :join_table => "authors_publications"
  validates_presence_of :name_plus_initials
end
