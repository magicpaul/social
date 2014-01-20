module ApplicationHelper
	def flash_class(type)
		case type
		when :alert
			return "alert"
		when :notice
			return "success"
		else
			return "warning"
		end
	end	
end
