module ApplicationHelper
	def flash_class(type)
		case type
		when :alert
			return "alert"
		when :notice
			return "success"
		when :success
			return "success"
		else
			return "warning"
		end
	end
	
	def can_display_status?(status)
		signed_in? && status.user == current_user || signed_in? && current_user.is_friends?(status.user) && !current_user.has_blocked?(status.user)
	end
end
