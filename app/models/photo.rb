class Photo < ActiveRecord::Base
  attr_accessible :description

  has_many :likes, :as => :likeable
end
