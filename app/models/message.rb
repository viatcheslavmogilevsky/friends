class Message < ActiveRecord::Base
  attr_accessible :content,:mark
  belongs_to :user

  belongs_to :target_user, :class_name => "User"

  scope :skip_marked, ->(ident) {where("mark <> ? OR mark IS ?",ident,nil)}
  validates :content, :presence => true
  validates_each :mark, :on => :create do |record,attribute,value|
    record.errors.add(attribute, "must be nil") unless value.nil?
  end

  has_one :notification, :as => :notificable, :dependent => :destroy

  after_create :make_notification
  paginates_per 10

  def mark_to_delete(user)
  	unless self.notification
  		if self.mark.nil?
  			self.update_attributes(:mark => user.id)
  		elsif self.mark != user.id 
  			 self.destroy
      end
  	else
  		self.destroy
  	end		
  end

  def make_notification
  	 self.create_notification
  end


end
