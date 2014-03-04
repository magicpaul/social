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
	def avatar_profile_link(user, image_options={}, html_options={})
		link_to(image_tag(user.gravatar_url, image_options), profile_path(user.profile_name), html_options)
	end
	def can_display_status?(status)
		signed_in? && status.user == current_user || signed_in? && current_user.is_friends?(status.user) && !current_user.has_blocked?(status.user)
	end
	def show_user_banner
		"background-image:url(#{@user.banner.url(:normal)})"
	end
end
