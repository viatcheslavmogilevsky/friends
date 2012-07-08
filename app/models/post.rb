class Post < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user
  belongs_to :target_user
end
