module ApplicationHelper
	def follow_link_id(object)
		"#{object.class.name}-#{object.id}"
	end
end
