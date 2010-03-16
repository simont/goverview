class Publication < ActiveRecord::Base
  has_many :annotations
end
