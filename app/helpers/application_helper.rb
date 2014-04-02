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
	def get_badge(score)
		case
		when score > 75
			return "gold"
		when score > 50
			return "silver"
		else
			return "bronze"
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
	def link_to_add_fields(name, f, association)
	    new_object = f.object.send(association).klass.new
	    id = new_object.object_id
	    fields = f.fields_for(association, new_object, child_index: id) do |builder|
	      render(association.to_s.singularize + "_fields", f: builder)
	    end
	    link_to(name, '#', class: "add_fields tiny button", data: {id: id, fields: fields.gsub("\n", "")})
	end
end
