module UsersHelper
	def get_links(user)
		if current_user.friend?(user)
			link_to("Delete from friends", delete_user_path(user), :method => :delete)
		elsif var = current_user.target_user?(user)
			link_to("Cancel invite", cancel_user_friendship_path(var), :method => :delete) 
		elsif var = current_user.candidate?(user)
			link_to("Accept invite", accept_user_friendship_path(var), :method => :put) + ' | ' +
			link_to("Cancel invite", cancel_user_friendship_path(var), :method => :delete) 
		else
			link_to("Add to friends", create_invite_user_path(user), :method => :post)
		end	
	end
end
