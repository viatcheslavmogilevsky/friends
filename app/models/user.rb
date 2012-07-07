class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :first_name, :nickname,
  				:description
  # attr_accessible :title, :body

  validate :name, {presence: true, length: {maximum: 30}}
  validate :first_name, {presence: true, length: {maximum: 30}}
  validate :nickname, {length: {maximum: 30}}

  has_many :user_friendships

  has_many :friendship_notifications, :class_name => "UserFriendship", 
  	:foreign_key => "target_user_id"

  has_and_belongs_to_many :friends, :class_name => "User",
    :foreign_key => "user_id",
    :association_foreign_key => "other_user_id",
    :join_table => :friendships  

  has_many :target_users, :through => :user_friendships,
  	:source => :target_user

  def delete_friend(some_user)
  	self.friends.delete(some_user)
  	some_user.friends.delete(self)
  end
    

end
