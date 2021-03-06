module StatusesHelper
    def can_display_status?(status)
        signed_in? && status.user == current_user || signed_in? && current_user.is_friends?(status.user) && !current_user.has_blocked?(status.user) || signed_in? && current_user.admin?
    end
    def can_edit_status?(status)
        signed_in? && current_user.admin? || signed_in? && status.user == current_user
    end
    def readable_points
        if current_user.points == 0
            "You don't have any points yet."
        else
            "You have #{current_user.points} points."
        end
    end
end
