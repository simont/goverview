class Taxon < ActiveRecord::Base
  has_many :annotations
end
