class PhotoAlbum < ActiveRecord::Base
  attr_accessible :name, :description

  validates :name, :presence => true

  belongs_to :user
  has_many :photos, :dependent => :destroy
end
