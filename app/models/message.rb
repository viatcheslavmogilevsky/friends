class Message < ActiveRecord::Base
  attr_accessible :content,:mark
  belongs_to :user

  belongs_to :target_user, :class_name => "User"

  scope :skip_marked, ->(ident) {where("mark <> ? OR mark IS ?",ident,nil)}

  has_one :notification, :as => :notificable

  after_create :make_notification

  def mark_to_delete(user)
  	unless self.notification
  		if self.mark.nil?
  			self.update_attributes(:mark => user.id)
  		else
  			self.destroy
  		end
  	else
  		self.notification.destroy
  		self.destroy
  	end		
  end

  def make_notification
  	 self.create_notification
  end


end
