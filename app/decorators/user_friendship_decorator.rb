class UserFriendshipDecorator < Draper::Decorator
  decorates :user_friendship
  delegate_all
  
  def friendship_state
  	model.state.titleize
  end
  def sub_message
  	case model.state
  	when 'pending'
  		"Friend request pending"
  	when 'accepted'
  		"You are friends with #{model.friend.full_name}."
    when 'requested'
      "Do you want to be friends with #{model.friend.full_name}?"
  	end
  end
  def update_action_verbiage
    case model.state
    when 'pending'
      'Delete'
    when 'requested'
      'Accept'
    when 'accepted'
      'Update'
    when 'blocked'
      'Unblock'
    end
  end
  
  def update_button_class
    case model.state
    when nil
      ''
    when 'pending'
      ''
    when 'requested'
       ''
    when 'accepted'
      ''
    when 'blocked'
     ''
    end
  end
  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end