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

	def show_user_banner
		"background-image:url(#{@user.banner.url(:normal)})"
	end
end
