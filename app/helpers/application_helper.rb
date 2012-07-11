module ApplicationHelper
	def get_friends_link(count)
		link_to("Friends#{count.zero? ? nil : ' (' + count.to_s + ')'}",friends_path)
	end
end
