module UsersHelper
	def get_links(user)
		if current_user.friend?(user)
			"<li>"+link_to("Delete from friends", delete_user_path(user), :method => :delete)+"</li>"
		elsif var = current_user.target_user?(user)
			"<li>"+link_to("Cancel invite", cancel_user_friendship_path(var), :method => :delete)+"</li>" 
		elsif var = current_user.candidate?(user)
			"<li>"+link_to("Accept invite", accept_user_friendship_path(var), :method => :put)+"</li>"+
			"<li>"+link_to("Cancel invite", cancel_user_friendship_path(var), :method => :delete) +"</li>"
		else
			"<li>"+link_to("Add to friends", create_invite_user_path(user), :method => :post)+"</li>"
		end	
	end
end
