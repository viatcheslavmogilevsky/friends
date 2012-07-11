module ApplicationHelper
	def get_friends_link(count)
		"<li>" + link_to("Friends#{count.zero? ? nil : ' (' + count.to_s + ')'}",friends_path) + "</li>"
	end
end
